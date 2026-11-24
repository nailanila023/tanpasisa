-- TANPASISA AUTH + PROFILE + ROLE SYNC MIGRATION
-- Jalankan SATU KALI di Supabase SQL Editor pada project yang sama dengan website.
-- Aman untuk role Admin yang sudah ada: trigger tidak pernah menimpa role admin.
-- Pendaftaran publik hanya boleh menghasilkan role seller/customer.

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  email text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "Users can read own profile" on public.profiles;
create policy "Users can read own profile"
on public.profiles for select to authenticated
using (user_id = auth.uid() or public.is_tanpasisa_admin());

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
on public.profiles for update to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

-- Trigger dijalankan di sisi database, sehingga tetap bekerja walau Supabase
-- meminta verifikasi email dan signUp() belum mengembalikan session.
create or replace function public.handle_tanpasisa_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  requested_role text;
  display_name text;
begin
  requested_role := lower(coalesce(new.raw_user_meta_data ->> 'role', 'customer'));
  if requested_role not in ('seller', 'customer') then
    requested_role := 'customer';
  end if;

  display_name := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
    split_part(coalesce(new.email, ''), '@', 1)
  );

  insert into public.user_roles(user_id, role)
  values (new.id, requested_role)
  on conflict (user_id) do nothing;

  insert into public.profiles(user_id, full_name, email)
  values (new.id, display_name, new.email)
  on conflict (user_id) do update
    set full_name = excluded.full_name,
        email = excluded.email,
        updated_at = now();

  return new;
end;
$$;

drop trigger if exists on_tanpasisa_auth_user_created on auth.users;
create trigger on_tanpasisa_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_tanpasisa_new_auth_user();

-- Backfill role untuk akun lama yang belum memiliki baris user_roles.
-- Role yang sudah ada (termasuk Admin) TIDAK ditimpa.
-- Jika metadata lama tidak memiliki role, akun tanpa role dianggap Customer.
insert into public.user_roles(user_id, role)
select
  u.id,
  case
    when lower(coalesce(u.raw_user_meta_data ->> 'role','')) = 'seller' then 'seller'
    else 'customer'
  end
from auth.users u
where not exists (
  select 1 from public.user_roles existing_role
  where existing_role.user_id = u.id
)
on conflict (user_id) do nothing;

insert into public.profiles(user_id, full_name, email)
select
  u.id,
  coalesce(nullif(trim(u.raw_user_meta_data ->> 'full_name'), ''), split_part(coalesce(u.email,''),'@',1)),
  u.email
from auth.users u
on conflict (user_id) do update
set full_name = excluded.full_name,
    email = excluded.email,
    updated_at = now();

-- Verifikasi: setiap akun Auth harus memiliki role dan profil.
select
  u.email,
  r.role,
  p.full_name,
  u.email_confirmed_at is not null as email_verified
from auth.users u
left join public.user_roles r on r.user_id = u.id
left join public.profiles p on p.user_id = u.id
order by u.created_at desc;

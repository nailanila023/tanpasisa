-- TANPASISA: berikan role Admin kepada enam akun tim.
-- PENTING:
-- 1. Undang/buat keenam akun lebih dahulu melalui Supabase Dashboard > Authentication > Users.
-- 2. Jalankan query ini setelah keenam email muncul di auth.users.
-- 3. Query ini TIDAK membuat/mengirim undangan; hanya memberi role admin pada akun yang sudah ada.
-- 4. Jangan pernah membagikan password atau service_role key.

with admin_emails(email) as (
  values
    ('fradibusa.23@gmail.com'),
    ('nila.23023@mhs.unesa.ac.id'),
    ('alifasaa.work@gmail.com'),
    ('nasywa.23227@mhs.unesa.ac.id'),
    ('alif.23035@mhs.unesa.ac.id'),
    ('robiatul.23481@mhs.unesa.ac.id')
)
insert into public.user_roles (user_id, role)
select u.id, 'admin'
from auth.users u
join admin_emails a on lower(u.email) = lower(a.email)
on conflict (user_id) do update
set role = 'admin';

-- Verifikasi enam akun:
select u.email, r.role, r.created_at
from public.user_roles r
join auth.users u on u.id = r.user_id
where lower(u.email) in (
  'fradibusa.23@gmail.com',
  'nila.23023@mhs.unesa.ac.id',
  'alifasaa.work@gmail.com',
  'nasywa.23227@mhs.unesa.ac.id',
  'alif.23035@mhs.unesa.ac.id',
  'robiatul.23481@mhs.unesa.ac.id'
)
order by u.email;

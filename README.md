# TANPASISA — Website + Admin Photo Upload (Supabase Cloud)

## Fitur baru
- Dashboard Admin memiliki tabel Kelola Produk untuk seluruh 500 SKU.
- Admin dapat memilih foto JPG, PNG, atau WEBP maksimal 5 MB.
- Preview foto sebelum disimpan.
- Tombol Simpan Foto mengunggah file ke Supabase Storage dan menyimpan URL-nya ke tabel `products`.
- Foto yang tersimpan akan ditampilkan di kartu produk pada halaman Shop dan beranda.
- Admin dapat menghapus foto; foto kembali ke ilustrasi default jika belum ada foto asli.
- Pengunjung dapat membaca katalog dan melihat foto tanpa login.
- Hanya akun yang diberi role `admin` di tabel `user_roles` yang dapat login sebagai Admin online dan mengelola foto.
- Produk disinkronkan dari Supabase ketika konfigurasi cloud sudah diisi.

## Pilihan hosting
Rekomendasi awal: Vercel untuk hosting website statis + Supabase untuk database, autentikasi, dan file storage.

## Setup Supabase (wajib sebelum upload online)
1. Buat project di https://supabase.com.
2. Buka SQL Editor, lalu jalankan seluruh isi `supabase/setup.sql`.
   - SQL membuat tabel produk, tabel role pengguna, RLS policies, bucket `product-images`, dan seed katalog 500 produk.
3. Buka Project Settings > API. Salin Project URL dan anon/public key.
4. Isi `supabase-config.js`:
   - `url`: Project URL Supabase.
   - `anonKey`: anon/public key.
   - Jangan pernah menaruh `service_role` key di frontend.
5. Di Supabase Authentication > Users, buat akun Admin menggunakan email/password.
6. Setelah akun dibuat, jalankan query ini di SQL Editor dengan email Admin yang benar:

```sql
insert into public.user_roles (user_id, role)
select id, 'admin'
from auth.users
where email = 'admin@tanpasisa.id'
on conflict (user_id) do update set role = 'admin';
```

Ganti `admin@tanpasisa.id` dengan email akun Admin yang dibuat. Jangan memberikan role admin kepada anggota tim yang tidak berwenang.

## Deploy ke Vercel
1. Ekstrak folder `tanpasisa-website`.
2. Buat repository GitHub dan unggah isi folder tersebut.
3. Login ke Vercel, pilih Add New > Project, lalu import repository GitHub.
4. Framework preset: Other. Build command: kosongkan. Output directory: `.` (root folder project).
5. Deploy. Setelah itu Vercel memberikan URL website.
6. Pastikan `supabase-config.js` sudah diisi sebelum deploy. Jika diubah setelah deploy, lakukan commit/push agar Vercel membangun ulang.

## Alur upload foto oleh Admin
1. Buka URL website online.
2. Pilih Akun > Masuk.
3. Pilih role Admin dan masuk menggunakan akun Supabase Admin.
4. Buka Dashboard Saya > Kelola Produk.
5. Cari produk pada tabel, pilih file gambar, periksa preview, lalu tekan Simpan Foto.
6. Foto akan disimpan ke bucket `product-images` dan URL produk diperbarui di database.
7. Untuk menghapus, tekan Hapus Foto. Produk kembali menggunakan ilustrasi default.

## Keamanan dan batasan
- Frontend menggunakan Supabase anon/public key; akses dibatasi oleh Row Level Security (RLS).
- `user_roles` tidak menyediakan pendaftaran role Admin dari frontend. Admin dibuat di Supabase Auth lalu role ditetapkan oleh pemilik project melalui SQL.
- Hanya Admin yang dapat update record produk dan upload/delete objek pada bucket.
- Pengunjung hanya dapat membaca katalog dan gambar.
- Foto disimpan publik agar gambar produk bisa dilihat di halaman Shop. Jangan mengunggah dokumen pribadi atau gambar sensitif.
- Maksimal ukuran file 5 MB; format JPG, PNG, WEBP.
- Fitur login lokal lama tetap tersedia untuk preview/demo. Untuk pengelolaan online, gunakan akun Supabase Admin.
- Ini paket siap konfigurasi, belum terhubung ke project Supabase atau Vercel milik pengguna. Perlu URL/key Supabase, pembuatan akun Admin, dan proses deploy sebelum fitur cloud aktif.
- Data contoh 500 produk perlu diverifikasi dengan mitra. Foto produk asli ditambahkan Admin satu per satu.


## Enam Admin dan deploy cloud
Lihat `ADMIN_SETUP.md` untuk panduan aktivasi Supabase, undangan enam Admin, deploy Vercel, dan alur upload foto. Query promosi enam Admin tersedia di `supabase/admins.sql`. Email Admin utama yang diminta adalah `fradibusa.23@gmail.com`; lima email lainnya perlu dilengkapi sebelum akun dapat diundang.


## Daftar enam Admin
Daftar email lengkap ada di `ADMIN_INVITATIONS.md`, CSV roster ada di `supabase/admin-roster-template.csv`, dan query penetapan role ada di `supabase/admins.sql`. Undangan harus dikirim dari Supabase Authentication oleh pemilik project.

Website TANPASISA
Website TANPASISA - Update GitHub
Update deployment TANPASISA dari GitHub.
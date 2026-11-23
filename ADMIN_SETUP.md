# TANPASISA — Aktivasi Cloud dan 6 Admin

## Pilihan teknologi
- Hosting: Vercel (direkomendasikan untuk paket ini karena sudah ada `vercel.json`; Netlify juga bisa).
- Database, Auth, dan Storage: Supabase.
- Akun pemilik proyek yang diminta: `fradibusa.23@gmail.com`.

## Status
Paket ini sudah berisi integrasi frontend Supabase untuk:
- Login Admin online melalui Supabase Auth.
- Mengambil katalog produk dari tabel `products`.
- Upload, preview, ganti, dan hapus foto produk melalui bucket `product-images`.
- Hak akses upload hanya untuk akun yang memiliki role `admin` pada `user_roles`.
- Foto publik agar dapat ditampilkan oleh semua pengunjung.

Paket belum tersambung ke project Supabase/Vercel karena project URL, anon key, dan lima alamat email Admin lainnya belum diberikan/dibuat oleh pemilik akun. Email saja tidak memberi akses untuk masuk ke akun atau membuat project atas nama pemilik.

## A. Buat project Supabase
1. Masuk ke https://supabase.com menggunakan akun pemilik `fradibusa.23@gmail.com`.
2. Buat project baru bernama `tanpasisa`.
3. Simpan database password di password manager; jangan kirim password ke chat.
4. Setelah project aktif, buka SQL Editor.
5. Jalankan seluruh file `supabase/setup.sql` satu kali. File ini membuat tabel, kebijakan RLS, bucket gambar, dan mengisi katalog contoh 500 produk.
6. Buka Project Settings > API. Salin Project URL dan anon/public key.
7. Isi `supabase-config.js` dengan Project URL dan anon/public key tersebut. Jangan pernah memasukkan `service_role` key ke file frontend atau repository publik.

## B. Buat enam akun Admin
Akun pertama yang diminta:
- `fradibusa.23@gmail.com`

Lima akun lainnya harus menggunakan lima alamat email unik milik anggota tim. Email harus dapat menerima undangan/reset password.

1. Buka Supabase Dashboard > Authentication > Users.
2. Pilih Invite user untuk masing-masing dari enam alamat email.
3. Setelah semua akun muncul di daftar Users, buka SQL Editor.
4. Edit `supabase/admins.sql`: ganti `EMAIL_ADMIN_2` sampai `EMAIL_ADMIN_6` dengan lima email anggota tim.
5. Jalankan file `supabase/admins.sql`.
6. Query verifikasi di bagian akhir akan menampilkan akun yang sudah memiliki role `admin`.
7. Setiap anggota menerima undangan dan mengatur password sendiri. Jangan menggunakan satu password bersama.

Jika email belum ada di Authentication > Users, query tidak akan membuat akun tersebut dan tidak akan memberi role. Undang akun itu terlebih dahulu, lalu jalankan ulang query.

## C. Konfigurasi dan deploy Vercel
1. Buat repository GitHub privat untuk proyek TANPASISA.
2. Unggah seluruh isi folder `tanpasisa-website` ke repository.
3. Pastikan `supabase-config.js` sudah diisi dengan URL dan anon/public key.
4. Login ke https://vercel.com menggunakan akun yang dipilih tim.
5. Import repository GitHub, Framework Preset pilih Other, Build Command kosong, Output Directory `.`.
6. Deploy. Vercel akan memberikan URL website.
7. Jika mengubah file konfigurasi atau kode, push perubahan ke GitHub agar deployment diperbarui.

## D. Alur Admin mengunggah foto
1. Admin membuka URL website publik.
2. Klik menu Akun > Masuk.
3. Pilih role Admin, lalu login dengan akun Supabase masing-masing.
4. Buka Dashboard Saya > Kelola Produk.
5. Cari nama produk atau merek.
6. Pilih foto JPG, PNG, atau WEBP (maksimal 5 MB).
7. Periksa preview, lalu klik Simpan Foto.
8. Foto disimpan di Supabase Storage dan URL-nya dicatat di tabel `products`.
9. Semua pengunjung akan melihat foto terbaru setelah halaman diperbarui.

## E. Keamanan
- `anon/public key` memang digunakan di browser; keamanan dijaga oleh Row Level Security.
- `service_role` key adalah rahasia server dan tidak boleh dimasukkan ke frontend.
- Hanya enam akun yang diberi role Admin yang dapat upload/update/delete foto.
- Pengunjung dapat membaca produk dan gambar.
- Bucket gambar publik: jangan mengunggah dokumen pribadi atau data sensitif.
- Setiap Admin sebaiknya memakai email dan password sendiri.
- Untuk menambah/mencabut Admin, pemilik project mengelola akun di Supabase Auth dan tabel `user_roles`.

## Yang masih dibutuhkan agar bisa diaktifkan
1. Project URL Supabase.
2. Supabase anon/public key.
3. Lima alamat email anggota tim selain `fradibusa.23@gmail.com`.
4. Pemilik project perlu membuat project dan melakukan deployment melalui akun miliknya.

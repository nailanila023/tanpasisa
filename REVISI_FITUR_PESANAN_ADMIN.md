# Revisi TANPASISA — Pesanan, Admin, dan Email

## Perubahan pada paket
- Email kontak publik diganti menjadi alifasaa.work@gmail.com.
- Checkout meminta login terlebih dahulu.
- Pembuatan pesanan disimpan ke tabel Supabase `orders`.
- Dashboard pelanggan menampilkan riwayat dan tombol lihat kode selama status Menunggu verifikasi.
- Seller/Admin dapat memverifikasi atau menolak pesanan; penolakan meminta alasan.
- Status pesanan dibaca dari database bersama sehingga perubahan status dapat diperbarui lintas dashboard.
- Admin mendapat editor nama produk, kategori, harga, harga normal, stok, outlet/mitra, serta kontrol upload foto yang sudah ada.

## Langkah wajib sebelum deploy
1. Backup proyek dan buka Supabase SQL Editor.
2. Jalankan ulang `supabase/setup.sql` yang sudah diperbarui (aman untuk tabel yang sudah ada; periksa output SQL).
3. Pastikan keenam akun tim sudah ada di Authentication > Users.
4. Jalankan `supabase/admins.sql` agar enam akun memiliki role Admin. Untuk akun Seller, buat akun dan beri role `seller` pada `public.user_roles`.
5. Pastikan `supabase-config.js` berisi Project URL dan anon/publishable key proyek yang benar. Jangan pernah memakai service_role key di browser.
6. Deploy ulang ke Vercel.

## Catatan penting
- Sinkronisasi online memerlukan Supabase aktif dan SQL terbaru. Jika belum, website tidak akan berpura-pura menyimpan pesanan cloud.
- Fungsi status yang dipakai di paket ini: Menunggu verifikasi, Terverifikasi, Ditolak. Verifikasi berarti pesanan disetujui untuk diproses/diambil, bukan otomatis transaksi pembayaran selesai.
- Seller dan Admin sama-sama dapat memverifikasi/menolak sesuai role database. Aturan RLS membatasi update pesanan untuk akun Admin/Seller.
- Untuk keamanan produksi, tambahkan validasi server-side yang lebih ketat dan audit log sebelum transaksi komersial nyata.

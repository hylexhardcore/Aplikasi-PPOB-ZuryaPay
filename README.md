# ZuryaPay Flutter Starter

Starter UI Android untuk ZuryaPay, aplikasi konsep PPOB dengan tema navy dan emas.

## Isi tahap pertama
- Halaman Login dan Registrasi (UI saja; belum autentikasi nyata)
- Dashboard dan saldo placeholder
- Menu E-Wallet, Paket Data, Pulsa, PLN, QRIS, Tagihan
- Halaman Riwayat dan Akun
- Navigasi dasar

## Cara menjalankan
1. Instal Flutter SDK dan Android SDK pada komputer/laptop.
2. Ekstrak proyek ini.
3. Buka terminal pada folder `zuryapay_flutter_starter`.
4. Jalankan:
   ```bash
   flutter pub get
   flutter run
   ```
5. Untuk membuat APK debug:
   ```bash
   flutter build apk --debug
   ```
   APK biasanya berada di `build/app/outputs/flutter-apk/app-debug.apk`.

## Catatan penting
Ini baru starter UI. Login/registrasi belum tersambung ke backend. Saldo bukan uang sungguhan dan tidak ada transaksi yang diproses. Jangan menerima dana pengguna memakai versi ini.

Sebelum uang sungguhan digunakan, buat backend aman dan database ledger, autentikasi, validasi webhook pembayaran, idempotensi transaksi, proteksi kredensial, serta integrasi penyedia pembayaran dan agregator PPOB yang sah. Jangan menyimpan secret API di aplikasi Flutter.

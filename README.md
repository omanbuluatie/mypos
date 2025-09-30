# Sistem Keuangan & Kasir Sederhana (Android, RDBMS Offline, Flutter Ready)

## 1. Ringkasan & Tujuan

Aplikasi kasir dan sistem keuangan untuk usaha kecil, berbasis Android
dengan **SQLite (offline RDBMS)**. Fokus awal: transaksi kasir (POS),
manajemen produk & stok, laporan harian sederhana, dan rekonsiliasi kas.
Target pengembangan selanjutnya: Flutter dengan opsi sinkronisasi cloud.

------------------------------------------------------------------------

## 2. Fitur Inti (MVP)

-   Autentikasi sederhana (PIN/password) dengan role (Owner, Manager,
    Kasir)
-   POS (Point of Sale) / layar kasir
-   Produk & inventaris (CRUD, stok real-time)
-   Pelanggan sederhana
-   Supplier & pembelian sederhana
-   Kas & shift (buka/tutup, rekonsiliasi kas)
-   Laporan dasar (penjualan harian, produk terlaris, stok rendah)
-   Backup/restore DB (ekspor/impor SQLite)
-   Audit log transaksi
-   Pengaturan dasar (toko, pajak, nota)

------------------------------------------------------------------------

## 3. Fitur Lengkap (Best Practice)

### A. Penjualan & POS

-   Multi-bayar (split payment)
-   Cetak thermal / A4 PDF
-   Return & refund
-   Kredit pelanggan (piutang)
-   Nomor meja / delivery order

### B. Inventory & Purchasing

-   Purchase order (PO) dan penerimaan barang
-   FIFO/average cost
-   Stock opname
-   Produk komposit / bundling

### C. Keuangan & Akuntansi Ringan

-   Buku kas masuk/keluar
-   Kategori biaya & pemasukan
-   Export CSV/Excel
-   Laporan laba rugi sederhana

### D. Manajemen Pengguna & Keamanan

-   Role-based access control
-   Audit trail lengkap
-   OTP / PIN transaksi sensitif

### E. Integrasi & Hardware

-   Printer thermal, cash-drawer, barcode scanner, payment gateway

### F. Offline-first & Sinkronisasi

-   Outbox pattern (change log) untuk sync
-   Conflict resolution policy

### G. UX & Operasional

-   Mode cepat (quick sale)
-   Shortcuts produk favorit
-   Multi-language/i18n

### H. Monitoring & Maintenance

-   Crash reporting
-   Auto-update data migrations

------------------------------------------------------------------------

## 4. Database Schema (Inti)

-   **users**
-   **products**
-   **stock_movements**
-   **customers**
-   **sales & sale_items**
-   **payments**
-   **shifts**
-   **audit_logs**
-   **change_log**

(Lihat detail SQL di dokumentasi database terpisah)

------------------------------------------------------------------------

## 5. Arsitektur & Teknologi

-   Arsitektur: Clean Architecture / MVVM + Repository
-   DB: SQLite (Flutter: drift/sqflite)
-   State management: Riverpod atau Bloc
-   Dependency Injection: get_it
-   Barcode scanner: mobile_scanner
-   Printer: esc_pos_bluetooth / printing
-   Secure storage: flutter_secure_storage
-   Background tasks: workmanager

------------------------------------------------------------------------

## 6. Alur Pengguna & Screens

-   Login / PIN
-   Dashboard (ringkasan penjualan & kas)
-   POS / Kasir layar (cart, pembayaran, cetak nota)
-   Produk (CRUD)
-   Pelanggan (CRUD)
-   Pembelian (PO & terima barang)
-   Stok (opname, riwayat)
-   Kas & Shift
-   Laporan
-   Pengaturan (toko, pajak, printer, backup, user)

------------------------------------------------------------------------

## 7. Todo List (Fase Bertahap)

### Fase 0 --- Persiapan

-   [ ] Requirement & user stories
-   [ ] Pilih stack & buat repo git
-   [ ] Wireframes UI
-   [ ] Draft schema DB

### Fase 1 --- Setup Proyek & DB

-   [ ] Inisialisasi project
-   [ ] Setup linting & CI
-   [ ] Implement login (PIN/password)
-   [ ] Setup SQLite (migrations awal)

### Fase 2 --- CRUD Produk & Stok

-   [ ] CRUD produk
-   [ ] Stock movement (adjustment)
-   [ ] Barcode search
-   [ ] Produk favorit (grid cepat)

### Fase 3 --- POS / Kasir Flow

-   [ ] Cart UI (add/edit qty, diskon)
-   [ ] Transaksi sales + stok berkurang
-   [ ] Pembayaran (tunai, non-tunai)
-   [ ] Invoice unik
-   [ ] Cetak nota (PDF/thermal)

### Fase 4 --- Kas/Shift

-   [ ] Buka shift & input kas awal
-   [ ] Tutup shift & rekonsiliasi
-   [ ] Kas keluar/masuk

### Fase 5 --- Laporan & Export

-   [ ] Laporan penjualan harian/mingguan
-   [ ] Laporan produk terlaris
-   [ ] Export CSV/Excel
-   [ ] Backup DB

### Fase 6 --- Pembelian & Supplier

-   [ ] Supplier CRUD
-   [ ] PO & penerimaan barang
-   [ ] Update harga modal & COGS

### Fase 7 --- Fitur Lanjutan

-   [ ] Return & refund
-   [ ] Diskon rules & kupon
-   [ ] Loyalty point

### Fase 8 --- Keamanan & Backup

-   [ ] Enkripsi DB (SQLCipher)
-   [ ] Secure storage
-   [ ] Crash reporting & analytics

### Fase 9 --- Sinkronisasi & Multi-terminal

-   [ ] Outbox/change_log pattern
-   [ ] API server & sync protocol
-   [ ] Multi-device sync

### Fase 10 --- Production Hardening

-   [ ] Performance tuning
-   [ ] Automated testing
-   [ ] Deployment ke Play Store
-   [ ] Dokumentasi end-user

------------------------------------------------------------------------

## 8. Best Practices

-   Gunakan transaksi DB untuk atomic operation
-   UUID unik untuk semua entitas
-   Indexing di kolom pencarian
-   Backup terjadwal
-   Audit log JSON snapshot
-   Graceful offline
-   Password hash (bcrypt/scrypt)
-   Data sensitif terenkripsi

------------------------------------------------------------------------

## 9. Next Steps

1.  Implementasi database & CRUD produk
2.  POS & transaksi dasar
3.  Kasir shift & laporan harian
4.  Testing & dokumentasi

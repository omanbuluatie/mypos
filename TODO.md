# TODO.md - Sistem Keuangan & Kasir Sederhana

## Fase 0 --- Persiapan

- [ ] Requirement & user stories
- [x] Pilih stack & buat repo git
- [ ] Wireframes UI
- [ ] Draft schema DB

## Fase 1 --- Setup Proyek & DB

- [x] Inisialisasi project
- [x] Setup linting & CI
- [x] Implement login (PIN/password)
- [x] Setup SQLite (migrations awal)

## Fase 2 --- CRUD Produk & Stok

- [ ] CRUD produk
- [ ] Stock movement (adjustment)
- [ ] Barcode search
- [ ] Produk favorit (grid cepat)

## Fase 3 --- POS / Kasir Flow

- [ ] Cart UI (add/edit qty, diskon)
- [ ] Transaksi sales + stok berkurang
- [ ] Pembayaran (tunai, non-tunai)
- [ ] Invoice unik
- [ ] Cetak nota (PDF/thermal)

## Fase 4 --- Kas/Shift

- [ ] Buka shift & input kas awal
- [ ] Tutup shift & rekonsiliasi
- [ ] Kas keluar/masuk

## Fase 5 --- Laporan & Export

- [ ] Laporan penjualan harian/mingguan
- [ ] Laporan produk terlaris
- [ ] Export CSV/Excel
- [ ] Backup DB

## Fase 6 --- Pembelian & Supplier

- [ ] Supplier CRUD
- [ ] PO & penerimaan barang
- [ ] Update harga modal & COGS

## Fase 7 --- Fitur Lanjutan

- [ ] Return & refund
- [ ] Diskon rules & kupon
- [ ] Loyalty point

## Fase 8 --- Keamanan & Backup

- [ ] Enkripsi DB (SQLCipher)
- [ ] Secure storage
- [ ] Crash reporting & analytics

## Fase 9 --- Sinkronisasi & Multi-terminal

- [ ] Outbox/change_log pattern
- [ ] API server & sync protocol
- [ ] Multi-device sync

## Fase 10 --- Production Hardening

- [ ] Performance tuning
- [ ] Automated testing
- [ ] Deployment ke Play Store
- [ ] Dokumentasi end-user

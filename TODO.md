- [x] Update Product model: Add description, unit, isService fields
- [x] Update database_helper.dart: Add new columns for description, unit, isService
- [x] Update ProductFormScreen: Add isService parameter, conditional fields, description, unit, barcode scan icon
- [x] Update ProductListScreen: Change title, add export/share buttons, barcode icon in search, "SEMUA PRODUK" label, FAB with options
- [x] Requirement & user stories
- [x] Pilih stack & buat repo git
- [x] Wireframes UI
- [x] Draft schema DB

## Fase 1 --- Setup Proyek & DB

- [x] Inisialisasi project
- [x] Setup linting & CI
- [x] Implement login (PIN/password)
- [x] Setup SQLite (migrations awal)
- [x] Improve UI for login and home screens




## Fase 2 --- CRUD Produk & Stok

- [x] CRUD produk
  - [x] Create Product model (lib/models/product.dart)
  - [x] Add products table to database_helper.dart
  - [x] Add CRUD methods to DatabaseHelper
  - [x] Create ProductProvider (lib/providers/product_provider.dart)
  - [x] Create ProductListScreen (lib/screens/product_list_screen.dart)
  - [x] Create ProductFormScreen (lib/screens/product_form_screen.dart)
  - [x] Update HomeScreen to navigate to products
  - [x] Update main.dart for product routes
- [x] Stock movement (adjustment)
- [x] Barcode search
- [x] Produk favorit (grid cepat)

## Fase 3 --- POS / Kasir Flow (Prioritas Tinggi - Core Business)

- [x] Kategori Produk
  - [x] Category model (id, name, description)
  - [x] Add categories table
  - [x] CategoryProvider
  - [x] Category CRUD screens
  - [x] Link products to categories
- [x] Data Stok (Stock Management)
  - [x] Stock movement tracking (in/out/adjustment)
  - [x] Stock adjustment screen
- [x] Paket Diskon (Discount Packages)
  - [x] Discount model (id, name, type, value, applicable_products)
  - [x] Add discounts table
  - [x] Discount management screens
- [x] Level Harga (Price Levels)
  - [x] Price level model (id, name, multiplier)
  - [x] Multiple prices per product
  - [x] Price level management

- [x] Penjualan (Sales Transaction)
  - [x] Create Sale model (id, date, customer_id, total, payment_method, status)
  - [x] Create SaleItem model (id, sale_id, product_id, qty, price, discount)
  - [x] Add sales and sale_items tables to database_helper.dart
  - [x] Add CRUD methods for sales and sale_items in DatabaseHelper
  - [x] Create SaleProvider and SaleItemProvider
  - [x] Create Cart screen (add products, edit qty, remove, calculate total)
  - [x] Create Payment screen (tunai, non-tunai options)
  - [x] Implement stock reduction on sale completion
  - [x] Generate unique invoice number
  - [x] Print receipt (basic text, later PDF/thermal)
  - [x] Integrate cart with etalase (add to cart functionality)
  - [x] buatkan di setiap produk di halaman etalase, ada tombol tambahkan ke kart, untuk menambahkan produk ke keranjang belanja

## Fase 4 --- Kas/Shift Management

- [x] Shift model (id, user_id, open_time, close_time, opening_balance, closing_balance)
- [x] Add shifts table to DB
- [x] ShiftProvider
- [x] Open shift screen (input kas awal)
- [x] Close shift screen (rekonsiliasi, hitung kas akhir)
- [x] Track kas keluar/masuk during shift

## Fase 5 --- Laporan & Export

- [x] Laporan Penjualan
  - [x] Laporan Harian (daily sales summary)
  - [x] Laporan Bulanan (monthly sales)
  - [x] Laporan Tahunan (yearly sales)
  - [x] Laporan Produk Terlaris (best selling products)
- [x] Laporan Keuangan
  - [x] Laporan Saldo (balance report)
  - [x] Arus Uang (cash flow report)
- [x] Export functionality (CSV/Excel for all reports)

## Fase 6 --- Pembelian & Supplier

- [x] Supplier CRUD
  - [x] Supplier model (id, name, contact, address)
  - [x] Add suppliers table
  - [x] SupplierProvider
  - [x] Supplier list, add/edit/delete screens
- [x] Purchase Order (PO)
  - [x] PO model (id, supplier_id, date, status, total)
  - [x] POItem model (id, po_id, product_id, qty, cost_price)
  - [x] Add po and po_items tables
  - [x] PO creation and management screens
- [x] Penerimaan Barang (Goods Receipt)
  - [x] Update stock on receipt
  - [x] Update harga modal & COGS
- [x] Retur Pembelian (Purchase Return)

## Fase 7 --- Kontak Management

- [ ] Data Customer
  - [ ] Customer model (id, name, phone, address, email)
  - [ ] Add customers table
  - [ ] CustomerProvider
  - [ ] Customer CRUD screens
- [ ] Data Supplier (already in Fase 6)

## Fase 8 --- Produk Advanced Features



## Fase 9 --- User Management

- [ ] Operator/User CRUD
  - [ ] User model extension (id, username, pin, role, name, email)
  - [ ] Update users table
  - [ ] UserProvider
  - [ ] User management screens (admin only)
  - [ ] Role-based access control

## Fase 10 --- Transaksi Keuangan Advanced

- [ ] Pengeluaran Umum (General Expenses)
  - [ ] Expense model (id, date, category, amount, description)
  - [ ] Add expenses table
  - [ ] Expense CRUD screens
- [ ] Hutang & Piutang (Debts & Receivables)
  - [ ] Debt model (id, type, party_id, amount, due_date, status)
  - [ ] Debt management screens
- [ ] Cashbox Management
  - [ ] Cash transaction tracking
  - [ ] Cash reconciliation

## Fase 11 --- Pengaturan & Konfigurasi

- [ ] Pengaturan Toko (Store Settings)
  - [ ] Store info model (name, address, phone, email)
  - [ ] Settings screen
- [ ] Pengaturan Password (Password Management)
  - [ ] Change password functionality
- [ ] Logo Management (Toko & Struk)
  - [ ] Image picker and storage
- [ ] Printer Settings
  - [ ] Printer configuration
  - [ ] Test print functionality
- [ ] Backup & Restore
  - [ ] Dropbox integration
  - [ ] Manual backup/restore
- [ ] Data Transfer & Reset
  - [ ] Export/import data
  - [ ] Factory reset

## Fase 12 --- Keamanan & Backup

- [ ] Enkripsi DB (SQLCipher)
- [ ] Secure storage for sensitive data
- [ ] Crash reporting & analytics

## Fase 13 --- Sinkronisasi & Multi-terminal

- [ ] Outbox/change_log pattern
- [ ] API server & sync protocol
- [ ] Multi-device sync

## Fase 14 --- Production Hardening

- [ ] Performance tuning
- [ ] Automated testing
- [ ] Deployment ke Play Store
- [ ] Dokumentasi end-user

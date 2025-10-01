import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/stock_movement.dart';
import '../models/discount.dart';
import '../models/price_level.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';
import '../models/shift.dart';
import '../models/cash_movement.dart';
import '../models/supplier.dart';
import '../models/po.dart';
import '../models/po_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mypos.db');
    return await openDatabase(
      path,
      version: 18, // Incremented version for po and po_items
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        pin TEXT,
        role TEXT
      )
    ''');
    await db.insert('users', {'username': 'kasir', 'pin': '1111', 'role': 'kasir'});
    await db.insert('users', {'username': 'manager', 'pin': '2222', 'role': 'manager'});
    await db.insert('users', {'username': 'owner', 'pin': '3333', 'role': 'owner'});

    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // Create products table (price column removed)
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        barcode TEXT,
        costPrice REAL NOT NULL,
        stock INTEGER NOT NULL,
        category_id INTEGER,
        favorite INTEGER DEFAULT 0,
        description TEXT,
        unit TEXT,
        isService INTEGER DEFAULT 0,
        image TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');

    // Create stock_movements table
    await db.execute('''
      CREATE TABLE stock_movements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        type TEXT NOT NULL,
        reason TEXT,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Create discounts table
    await db.execute('''
      CREATE TABLE discounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL
      )
    ''');

    // Create discount_products join table
    await db.execute('''
      CREATE TABLE discount_products (
        discount_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        PRIMARY KEY (discount_id, product_id),
        FOREIGN KEY (discount_id) REFERENCES discounts (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Create price_levels table
    await db.execute('''
      CREATE TABLE price_levels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');
    // Insert a default price level
    await db.insert('price_levels', {'name': 'Retail'});

    // Create product_prices table
    await db.execute('''
      CREATE TABLE product_prices (
        product_id INTEGER NOT NULL,
        price_level_id INTEGER NOT NULL,
        price REAL NOT NULL,
        PRIMARY KEY (product_id, price_level_id),
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
        FOREIGN KEY (price_level_id) REFERENCES price_levels (id) ON DELETE CASCADE
      )
    ''');

    // Create sales table
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        customer_id INTEGER,
        total REAL NOT NULL,
        payment_method TEXT NOT NULL,
        status TEXT NOT NULL,
        invoice_number TEXT
      )
    ''');

    // Create sale_items table
    await db.execute('''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        qty INTEGER NOT NULL,
        price REAL NOT NULL,
        discount REAL NOT NULL,
        FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Create shifts table
    await db.execute('''
      CREATE TABLE shifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        open_time TEXT NOT NULL,
        close_time TEXT,
        opening_balance REAL NOT NULL,
        closing_balance REAL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Create cash_movements table
    await db.execute('''
      CREATE TABLE cash_movements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shift_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        reason TEXT,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (shift_id) REFERENCES shifts (id) ON DELETE CASCADE
      )
    ''');

    // Create suppliers table
    await db.execute('''
      CREATE TABLE suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        contact TEXT,
        address TEXT
      )
    ''');

    // Create po table
    await db.execute('''
      CREATE TABLE po (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        supplier_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE CASCADE
      )
    ''');

    // Create po_items table
    await db.execute('''
      CREATE TABLE po_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        po_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        qty INTEGER NOT NULL,
        cost_price REAL NOT NULL,
        FOREIGN KEY (po_id) REFERENCES po (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 13) {
        await db.execute('DROP TABLE IF EXISTS product_prices');
        await db.execute('DROP TABLE IF EXISTS price_levels');
        await db.execute('DROP TABLE IF EXISTS discount_products');
        await db.execute('DROP TABLE IF EXISTS discounts');
        await db.execute('DROP TABLE IF EXISTS stock_movements');
        await db.execute('DROP TABLE IF EXISTS products');
        await db.execute('DROP TABLE IF EXISTS categories');
        await db.execute('DROP TABLE IF EXISTS users');
        await _onCreate(db, newVersion);
    } else if (oldVersion < 14) {
      // Add sales and sale_items tables
      await db.execute('''
        CREATE TABLE sales (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          customer_id INTEGER,
          total REAL NOT NULL,
          payment_method TEXT NOT NULL,
          status TEXT NOT NULL,
          invoice_number TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE sale_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          qty INTEGER NOT NULL,
          price REAL NOT NULL,
          discount REAL NOT NULL,
          FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE,
          FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
        )
      ''');
    } else if (oldVersion < 15) {
      // Add shifts table
      await db.execute('''
        CREATE TABLE shifts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          open_time TEXT NOT NULL,
          close_time TEXT,
          opening_balance REAL NOT NULL,
          closing_balance REAL,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
    } else if (oldVersion < 16) {
      // Add cash_movements table
      await db.execute('''
        CREATE TABLE cash_movements (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          shift_id INTEGER NOT NULL,
          type TEXT NOT NULL,
          amount REAL NOT NULL,
          reason TEXT,
          timestamp TEXT NOT NULL,
          FOREIGN KEY (shift_id) REFERENCES shifts (id) ON DELETE CASCADE
        )
      ''');
    } else if (oldVersion < 17) {
      // Add suppliers table
      await db.execute('''
        CREATE TABLE suppliers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          contact TEXT,
          address TEXT
        )
      ''');
    } else if (oldVersion < 18) {
      // Add po and po_items tables
      await db.execute('''
        CREATE TABLE po (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          supplier_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          status TEXT NOT NULL,
          total REAL NOT NULL,
          FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE CASCADE
        )
      ''');
      await db.execute('''
        CREATE TABLE po_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          po_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          qty INTEGER NOT NULL,
          cost_price REAL NOT NULL,
          FOREIGN KEY (po_id) REFERENCES po (id) ON DELETE CASCADE,
          FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  // --- Product Methods ---
  Future<Product> insertProduct(Product product) async {
    final db = await database;
    await db.transaction((txn) async {
      int id = await txn.insert('products', product.toMap());
      product.id = id;
      for (var entry in product.prices.entries) {
        await txn.insert('product_prices', {
          'product_id': id,
          'price_level_id': entry.key,
          'price': entry.value,
        });
      }
    });
    return product;
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> productMaps = await db.query('products');
    List<Product> products = [];
    for (var map in productMaps) {
      final product = Product.fromMap(map);
      final List<Map<String, dynamic>> priceMaps = await db.query(
        'product_prices',
        where: 'product_id = ?',
        whereArgs: [product.id],
      );
      product.prices = { for (var pMap in priceMaps) pMap['price_level_id'] : pMap['price'] };
      products.add(product);
    }
    return products;
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    int result = 0;
    await db.transaction((txn) async {
      result = await txn.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
      await txn.delete('product_prices', where: 'product_id = ?', whereArgs: [product.id]);
      for (var entry in product.prices.entries) {
        await txn.insert('product_prices', {
          'product_id': product.id,
          'price_level_id': entry.key,
          'price': entry.value,
        });
      }
    });
    return result;
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // --- Stock, Category, Discount Methods (condensed for brevity) ---
  Future<void> adjustStock({required int id, required int adjustment, required String type, String? reason}) async {
    Database db = await database;
    await db.transaction((txn) async {
      List<Map<String, dynamic>> result = await txn.query('products', columns: ['stock'], where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        int currentStock = result.first['stock'];
        int newStock = currentStock + adjustment;
        await txn.update('products', {'stock': newStock}, where: 'id = ?', whereArgs: [id]);
        final movement = StockMovement(productId: id, quantity: adjustment, type: type, reason: reason, timestamp: DateTime.now());
        await txn.insert('stock_movements', movement.toMap());
      }
    });
  }
  
  Future<List<Discount>> getDiscounts() async {
    final db = await database;
    final List<Map<String, dynamic>> discountMaps = await db.query('discounts');
    List<Discount> discounts = [];
    for (var map in discountMaps) {
      final discount = Discount.fromMap(map);
      final List<Map<String, dynamic>> productMaps = await db.query('discount_products', columns: ['product_id'], where: 'discount_id = ?', whereArgs: [discount.id]);
      discount.productIds = productMaps.map((pMap) => pMap['product_id'] as int).toList();
      discounts.add(discount);
    }
    return discounts;
  }

  Future<Discount> insertDiscount(Discount discount) async {
    final db = await database;
    await db.transaction((txn) async {
      int id = await txn.insert('discounts', discount.toMap());
      discount.id = id;
      for (int productId in discount.productIds) {
        await txn.insert('discount_products', {'discount_id': discount.id, 'product_id': productId});
      }
    });
    return discount;
  }

  Future<int> updateDiscount(Discount discount) async {
    final db = await database;
    int result = 0;
    await db.transaction((txn) async {
      result = await txn.update('discounts', discount.toMap(), where: 'id = ?', whereArgs: [discount.id]);
      await txn.delete('discount_products', where: 'discount_id = ?', whereArgs: [discount.id]);
      for (int productId in discount.productIds) {
        await txn.insert('discount_products', {'discount_id': discount.id, 'product_id': productId});
      }
    });
    return result;
  }

  Future<int> deleteDiscount(int id) async {
    final db = await database;
    return await db.delete('discounts', where: 'id = ?', whereArgs: [id]);
  }

  // --- Price Level Methods ---
  Future<List<PriceLevel>> getPriceLevels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('price_levels');
    return List.generate(maps.length, (i) => PriceLevel.fromMap(maps[i]));
  }

  Future<PriceLevel> insertPriceLevel(PriceLevel priceLevel) async {
    final db = await database;
    int id = await db.insert('price_levels', priceLevel.toMap());
    priceLevel.id = id;
    return priceLevel;
  }

  Future<int> updatePriceLevel(PriceLevel priceLevel) async {
    final db = await database;
    return await db.update('price_levels', priceLevel.toMap(), where: 'id = ?', whereArgs: [priceLevel.id]);
  }

  Future<int> deletePriceLevel(int id) async {
    final db = await database;
    // TODO: Consider what happens to product_prices when a level is deleted.
    // The current schema will throw an error. We might need to delete them manually first.
    return await db.delete('price_levels', where: 'id = ?', whereArgs: [id]);
  }

  // --- Category Methods ---
  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<Category> insertCategory(Category category) async {
    final db = await database;
    int id = await db.insert('categories', category.toMap());
    category.id = id;
    return category;
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // --- Sale Methods ---
  Future<Sale> insertSale(Sale sale) async {
    final db = await database;
    int id = await db.insert('sales', sale.toMap());
    sale.id = id;
    return sale;
  }

  Future<List<Sale>> getSales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sales');
    return List.generate(maps.length, (i) => Sale.fromMap(maps[i]));
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Sale.fromMap(maps[i]));
  }

  Future<List<Sale>> getSalesByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return getSalesByDateRange(start, end);
  }

  Future<List<Sale>> getSalesByYear(int year) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return getSalesByDateRange(start, end);
  }

  Future<List<Map<String, dynamic>>> getBestSellingProducts(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.id as product_id, p.name, SUM(si.qty) as total_qty
      FROM sale_items si
      JOIN products p ON si.product_id = p.id
      GROUP BY si.product_id
      ORDER BY total_qty DESC
      LIMIT ?
    ''', [limit]);
    return maps;
  }

  Future<int> updateSale(Sale sale) async {
    final db = await database;
    return await db.update('sales', sale.toMap(), where: 'id = ?', whereArgs: [sale.id]);
  }

  Future<int> deleteSale(int id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  // --- SaleItem Methods ---
  Future<List<SaleItem>> getSaleItems(int saleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sale_items', where: 'sale_id = ?', whereArgs: [saleId]);
    return List.generate(maps.length, (i) => SaleItem.fromMap(maps[i]));
  }

  Future<SaleItem> insertSaleItem(SaleItem item) async {
    final db = await database;
    int id = await db.insert('sale_items', item.toMap());
    item.id = id;
    return item;
  }

  Future<int> updateSaleItem(SaleItem item) async {
    final db = await database;
    return await db.update('sale_items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteSaleItem(int id) async {
    final db = await database;
    return await db.delete('sale_items', where: 'id = ?', whereArgs: [id]);
  }

  // --- Shift Methods ---
  Future<Shift> insertShift(Shift shift) async {
    final db = await database;
    int id = await db.insert('shifts', shift.toMap());
    shift.id = id;
    return shift;
  }

  Future<List<Shift>> getShifts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shifts');
    return List.generate(maps.length, (i) => Shift.fromMap(maps[i]));
  }

  Future<int> updateShift(Shift shift) async {
    final db = await database;
    return await db.update('shifts', shift.toMap(), where: 'id = ?', whereArgs: [shift.id]);
  }

  Future<int> deleteShift(int id) async {
    final db = await database;
    return await db.delete('shifts', where: 'id = ?', whereArgs: [id]);
  }

  Future<Shift?> getOpenShift(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shifts', where: 'user_id = ? AND close_time IS NULL', whereArgs: [userId]);
    if (maps.isNotEmpty) {
      return Shift.fromMap(maps.first);
    }
    return null;
  }

  // --- Cash Movement Methods ---
  Future<CashMovement> insertCashMovement(CashMovement movement) async {
    final db = await database;
    int id = await db.insert('cash_movements', movement.toMap());
    movement.id = id;
    return movement;
  }

  Future<List<CashMovement>> getCashMovementsByShift(int shiftId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cash_movements', where: 'shift_id = ?', whereArgs: [shiftId]);
    return List.generate(maps.length, (i) => CashMovement.fromMap(maps[i]));
  }

  Future<int> updateCashMovement(CashMovement movement) async {
    final db = await database;
    return await db.update('cash_movements', movement.toMap(), where: 'id = ?', whereArgs: [movement.id]);
  }

  Future<int> deleteCashMovement(int id) async {
    final db = await database;
    return await db.delete('cash_movements', where: 'id = ?', whereArgs: [id]);
  }

  // --- Balance Report Methods ---
  Future<double> getTotalSales() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(total) as total FROM sales');
    return result.first['total'] ?? 0.0;
  }

  Future<double> getTotalCashIn() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery("SELECT SUM(amount) as total FROM cash_movements WHERE type = 'in'");
    return result.first['total'] ?? 0.0;
  }

  Future<double> getTotalCashOut() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery("SELECT SUM(amount) as total FROM cash_movements WHERE type = 'out'");
    return result.first['total'] ?? 0.0;
  }

  // --- Cash Flow Report Methods ---
  Future<List<CashMovement>> getCashMovementsByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cash_movements',
      where: 'timestamp >= ? AND timestamp < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => CashMovement.fromMap(maps[i]));
  }

  // --- Supplier Methods ---
  Future<List<Supplier>> getSuppliers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('suppliers');
    return List.generate(maps.length, (i) => Supplier.fromMap(maps[i]));
  }

  Future<Supplier> insertSupplier(Supplier supplier) async {
    final db = await database;
    int id = await db.insert('suppliers', supplier.toMap());
    supplier.id = id;
    return supplier;
  }

  Future<int> updateSupplier(Supplier supplier) async {
    final db = await database;
    return await db.update('suppliers', supplier.toMap(), where: 'id = ?', whereArgs: [supplier.id]);
  }

  Future<int> deleteSupplier(int id) async {
    final db = await database;
    return await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }

  // --- PO Methods ---
  Future<PO> insertPO(PO po) async {
    final db = await database;
    int id = await db.insert('po', po.toMap());
    po.id = id;
    return po;
  }

  Future<List<PO>> getPOs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('po');
    return List.generate(maps.length, (i) => PO.fromMap(maps[i]));
  }

  Future<int> updatePO(PO po) async {
    final db = await database;
    return await db.update('po', po.toMap(), where: 'id = ?', whereArgs: [po.id]);
  }

  Future<int> deletePO(int id) async {
    final db = await database;
    return await db.delete('po', where: 'id = ?', whereArgs: [id]);
  }

  // --- POItem Methods ---
  Future<List<POItem>> getPOItems(int poId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('po_items', where: 'po_id = ?', whereArgs: [poId]);
    return List.generate(maps.length, (i) => POItem.fromMap(maps[i]));
  }

  Future<POItem> insertPOItem(POItem item) async {
    final db = await database;
    int id = await db.insert('po_items', item.toMap());
    item.id = id;
    return item;
  }

  Future<int> updatePOItem(POItem item) async {
    final db = await database;
    return await db.update('po_items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deletePOItem(int id) async {
    final db = await database;
    return await db.delete('po_items', where: 'id = ?', whereArgs: [id]);
  }

  // --- Receive PO Methods ---
  Future<void> receivePO(int poId) async {
    final db = await database;
    // Update PO status to 'received'
    await db.update('po', {'status': 'received'}, where: 'id = ?', whereArgs: [poId]);
    // Get PO items
    final poItems = await getPOItems(poId);
    for (var item in poItems) {
      // Update product stock and cost price
      await db.rawUpdate(
        'UPDATE products SET stock = stock + ?, costPrice = ? WHERE id = ?',
        [item.qty, item.costPrice, item.productId],
      );
      // Add stock movement
      await db.insert('stock_movements', {
        'product_id': item.productId,
        'quantity': item.qty,
        'type': 'in',
        'reason': 'PO Receipt',
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  // --- Return PO Methods ---
  Future<void> returnPO(int poId) async {
    final db = await database;
    // Update PO status to 'returned'
    await db.update('po', {'status': 'returned'}, where: 'id = ?', whereArgs: [poId]);
    // Get PO items
    final poItems = await getPOItems(poId);
    for (var item in poItems) {
      // Update product stock (reduce)
      await db.rawUpdate(
        'UPDATE products SET stock = stock - ? WHERE id = ?',
        [item.qty, item.productId],
      );
      // Add stock movement
      await db.insert('stock_movements', {
        'product_id': item.productId,
        'quantity': -item.qty,
        'type': 'out',
        'reason': 'PO Return',
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }
}

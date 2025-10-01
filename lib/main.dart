import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/stock_adjustment_screen.dart';
import 'screens/category_list_screen.dart';
import 'screens/category_form_screen.dart';
import 'screens/image_search_screen.dart';
import 'screens/discount_list_screen.dart';
import 'screens/discount_form_screen.dart';
import 'screens/price_level_list_screen.dart';
import 'screens/price_level_form_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/daily_sales_report_screen.dart';
import 'screens/monthly_sales_report_screen.dart';
import 'screens/yearly_sales_report_screen.dart';
import 'screens/best_selling_products_screen.dart';
import 'screens/balance_report_screen.dart';
import 'screens/cash_flow_report_screen.dart';
import 'screens/supplier_list_screen.dart';
import 'screens/supplier_form_screen.dart';
import 'screens/po_list_screen.dart';
import 'screens/po_form_screen.dart';
import 'providers/auth_provider.dart';
import 'models/product.dart'; // Import the Product model
import 'models/price_level.dart'; // Import the PriceLevel model
import 'models/supplier.dart'; // Import the Supplier model
import 'models/po.dart'; // Import the PO model

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Kasir Toko Portable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authState.isLoggedIn ? HomeScreen() : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/products': (context) => ProductListScreen(),
        '/product_form': (context) => ProductFormScreen(),
        '/stock_adjustment': (context) {
          final product = ModalRoute.of(context)?.settings.arguments as Product?;
          return StockAdjustmentScreen(product: product);
        },
        '/categories': (context) => CategoryListScreen(),
        '/category_form': (context) => CategoryFormScreen(),
        '/image_search': (context) => ImageSearchScreen(),
        '/discounts': (context) => DiscountListScreen(),
        '/discount_form': (context) => DiscountFormScreen(),
        '/price_levels': (context) => PriceLevelListScreen(),
        '/price_level_form': (context) {
          final priceLevel = ModalRoute.of(context)?.settings.arguments as PriceLevel?;
          return PriceLevelFormScreen();
        },
        '/cart': (context) => CartScreen(),
        '/payment': (context) => PaymentScreen(),
        '/daily_sales_report': (context) => DailySalesReportScreen(),
        '/monthly_sales_report': (context) => MonthlySalesReportScreen(),
        '/yearly_sales_report': (context) => YearlySalesReportScreen(),
        '/best_selling_products': (context) => BestSellingProductsScreen(),
        '/balance_report': (context) => BalanceReportScreen(),
        '/cash_flow_report': (context) => CashFlowReportScreen(),
        '/suppliers': (context) => SupplierListScreen(),
        '/supplier_form': (context) {
          final supplier = ModalRoute.of(context)?.settings.arguments as Supplier?;
          return SupplierFormScreen();
        },
        '/pos': (context) => POListScreen(),
        '/po_form': (context) {
          final po = ModalRoute.of(context)?.settings.arguments as PO?;
          return POFormScreen();
        },
      },
    );
  }
}

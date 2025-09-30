import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For simplicity, check auth state here, but in real app, use a FutureBuilder or something
    // Since auth loads asynchronously, this might not work perfectly, but for demo ok
    final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'MyPOS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authState.isLoggedIn ? HomeScreen() : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

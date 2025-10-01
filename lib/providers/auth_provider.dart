import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/role.dart';

class AuthState {
  final bool isLoggedIn;
  final Role? role;
  final int? userId;

  AuthState({required this.isLoggedIn, this.role, this.userId});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false)) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final roleString = prefs.getString('role');
    final userId = prefs.getInt('userId');
    Role? role;
    if (roleString != null) {
      role = Role.values.firstWhere((e) => e.name == roleString);
    }
    state = AuthState(isLoggedIn: isLoggedIn, role: role, userId: userId);
  }

  Future<bool> login(String pin) async {
    Role? role;
    int? userId;
    if (pin == '1111') {
      role = Role.kasir;
      userId = 1;
    } else if (pin == '2222') {
      role = Role.manager;
      userId = 2;
    } else if (pin == '3333') {
      role = Role.owner;
      userId = 3;
    } else return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('role', role.name);
    await prefs.setInt('userId', userId);
    state = AuthState(isLoggedIn: true, role: role, userId: userId);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('role');
    await prefs.remove('userId');
    state = AuthState(isLoggedIn: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

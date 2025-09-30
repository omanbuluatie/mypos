import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/role.dart';

class AuthState {
  final bool isLoggedIn;
  final Role? role;

  AuthState({required this.isLoggedIn, this.role});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false)) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final roleString = prefs.getString('role');
    Role? role;
    if (roleString != null) {
      role = Role.values.firstWhere((e) => e.name == roleString);
    }
    state = AuthState(isLoggedIn: isLoggedIn, role: role);
  }

  Future<bool> login(String pin) async {
    Role? role;
    if (pin == '1111') role = Role.kasir;
    else if (pin == '2222') role = Role.manager;
    else if (pin == '3333') role = Role.owner;
    else return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('role', role.name);
    state = AuthState(isLoggedIn: true, role: role);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('role');
    state = AuthState(isLoggedIn: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

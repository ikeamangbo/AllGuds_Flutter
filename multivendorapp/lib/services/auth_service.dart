import 'dart:async';
import 'user_service.dart';

class AuthService {
  final UserService _userService = UserService();
  final _authStateController = StreamController<bool>.broadcast();

  Stream<bool> get authStateChanges => _authStateController.stream;

  AuthService() {
    // Check initial auth state
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    final isLoggedIn = await _userService.isLoggedIn();
    _authStateController.add(isLoggedIn);
  }

  Future<bool> login(String email, String password) async {
    final success = await _userService.login(email, password);
    if (success) {
      _authStateController.add(true);
    }
    return success;
  }

  Future<bool> register(String email, String password, {String role = 'buyer'}) async {
    return await _userService.register(email, password, role: role);
  }

  Future<void> logout() async {
    await _userService.logout();
    _authStateController.add(false);
  }

  void dispose() {
    _authStateController.close();
  }
} 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    return await _apiService.validateToken(token);
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response['success'] && response['data']['token'] != null) {
        await saveToken(response['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    await removeToken();
  }

  // Register user
  Future<bool> register(String email, String password,
      {String role = 'buyer'}) async {
    try {
      final response = await _apiService.register(email, password, role);
      return response['success'] ?? false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Remove token (logout)
  Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Store user token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
}

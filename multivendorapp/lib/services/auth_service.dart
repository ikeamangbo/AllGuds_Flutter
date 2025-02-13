import 'dart:async';
import 'user_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final UserService _userService = UserService();
  final _authStateController = StreamController<bool>.broadcast();
  final String baseUrl =
      'http://10.0.2.2:3001/api/auth'; // For Android Emulator
  final storage = const FlutterSecureStorage();

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

  Future<bool> register(String email, String password,
      {String role = 'buyer'}) async {
    return await _userService.register(email, password, role: role);
  }

  Future<void> logout() async {
    await _userService.logout();
    _authStateController.add(false);
  }

  void dispose() {
    _authStateController.close();
  }

  // Register user
  Future<Map<String, dynamic>> registerUser(
      String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['token']);
        await storage.write(key: 'user', value: jsonEncode(data['user']));
        return data;
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['token']);
        await storage.write(key: 'user', value: jsonEncode(data['user']));
        return data;
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userStr = await storage.read(key: 'user');
    if (userStr != null) {
      return jsonDecode(userStr);
    }
    return null;
  }

  // Get token
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Validate token
  Future<bool> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Check for stored auth on startup
  Future<bool> checkStoredAuth() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) return false;

      // Validate the token
      final isValid = await validateToken(token);
      if (!isValid) {
        await storage.delete(key: 'token');
        await storage.delete(key: 'user');
        return false;
      }

      _authStateController.add(true);
      return true;
    } catch (e) {
      print('Error checking stored auth: $e');
      return false;
    }
  }

  // Get stored user
  Future<Map<String, dynamic>?> getStoredUser() async {
    try {
      final userStr = await storage.read(key: 'user');
      if (userStr != null) {
        return jsonDecode(userStr);
      }
      return null;
    } catch (e) {
      print('Error getting stored user: $e');
      return null;
    }
  }
}

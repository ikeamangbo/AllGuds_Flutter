import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://172.27.16.1:3001/api/auth'; // Auth service URL
  static const String productBaseUrl =
      'http://10.0.2.2:3002/api'; // Product service URL

  // Authentication endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String validateTokenEndpoint = '/auth/validate-token';

  // Product endpoints
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$productBaseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Raw API response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // The data is directly in 'data' array, not nested in 'products'
        if (responseData['data'] != null) {
          final List<dynamic> products = responseData['data'];
          return List<Map<String, dynamic>>.from(products);
        }
        return [];
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Handle login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login with email: $email'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Login response: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Handle registration
  Future<Map<String, dynamic>> register(
      String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            jsonDecode(response.body)['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Validate token
  Future<bool> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$validateTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

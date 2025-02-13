import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../config/config.dart';

class ProductService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3002/api'; // For Android emulator

  Future<String> _uploadImage(XFile imageFile) async {
    try {
      final uri = Uri.parse(Config.cloudinaryUploadUrl);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      var request = http.MultipartRequest('POST', uri);

      // Add file
      final bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Add fields in same order as web
      request.fields.addAll({
        'upload_preset': Config.cloudinaryUploadPreset,
        'folder': 'products',
        'cloud_name': Config.cloudinaryCloudName,
        'api_key': Config.cloudinaryApiKey,
        'timestamp': timestamp.toString(),
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return data['secure_url'];
      } else {
        throw 'Failed to upload image: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }

  Future<void> createProduct({
    required String name,
    required String desc,
    required String type,
    required double price,
    required int stock,
    required XFile imageFile,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw 'No authentication token found';

      // First upload image to Cloudinary
      final imageUrl = await _uploadImage(imageFile);

      // Then create product
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'desc': desc,
          'type': type,
          'price': price,
          'stock': stock,
          'img': imageUrl,
          'available': true,
        }),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw errorData['message'] ?? 'Failed to create product';
      }
    } catch (e) {
      throw 'Failed to create product: $e';
    }
  }
}

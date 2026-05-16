import 'dart:convert';
import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/constants/api_costants.dart';
import 'package:feed_flix/core/storage_services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = baseApi});

  Future<Map<String, String>> get _headers async {
    final headers = {'Content-Type': 'application/json'};
    return headers;
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: await _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  Future<dynamic> multipartRequest({
    required String endpoint,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));

      request.headers.addAll(await _headers);
      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Upload error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 202:
        return jsonDecode(response.body);
      case 400:
        throw ServerException('Bad Request');
      case 401:
        throw ServerException('Unauthorized');
      case 403:
        throw ServerException('Forbidden');
      case 404:
        throw ServerException('Not Found');
      case 500:
        throw ServerException('Internal Server Error');
      default:
        throw ServerException('Error: ${response.statusCode}');
    }
  }
}

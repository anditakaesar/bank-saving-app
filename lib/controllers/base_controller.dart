import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class BaseController {
  final String baseUrl = 'https://bank-saving-server.akae.xyz/api';

  Map<String, String> get headers => {
    'Authorization': 'Bearer 1223334444',
    'Content-Type': 'application/json',
  };

  Future<http.Response> getRequest(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParams);
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> postRequest(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final jsonBody = json.encode(body);
    return await http.post(uri, headers: headers, body: jsonBody);
  }

  Future<http.Response> patchRequest(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return await http.patch(uri, headers: headers, body: json.encode(body));
  }

  Future<http.Response> deleteRequest(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return await http.delete(uri, headers: headers);
  }
}

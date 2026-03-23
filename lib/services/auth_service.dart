import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resqlink/globals.dart' as globals;

class AuthService {
  static const String baseUrl = '${globals.domain}/account';

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data.toString());
    }
  }

  Future<Map<String, dynamic>> registerCustomer({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/customer/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data.toString());
    }
  }

  Future<Map<String, dynamic>> getProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('ME STATUS CODE: ${response.statusCode}');
    print('ME RESPONSE BODY: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data.toString());
    }
  }
}
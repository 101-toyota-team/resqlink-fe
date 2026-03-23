import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:resqlink/globals.dart';


/// Service for handling authentication operations
/// Manages login, registration, and user profile requests
class AuthService {
  static final String _baseUrl = AppConstants.apiBaseUrl;

  /// Logs in a user with the provided credentials
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/account/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return data;
    } else {
      throw AuthException(data['detail'] ?? 'Login failed');
    }
  }

  /// Registers a new customer account

  Future<Map<String, dynamic>> registerCustomer({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/account/register/customer/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      return data;
    } else {
      throw AuthException(data['detail'] ?? 'Registration failed');
    }
  }

  /// Registers a new provider/institution account
  Future<Map<String, dynamic>> registerProvider({
    required String institutionName,
    required String email,
    required String phone,
    required String adminUsername,
    required String adminPassword,
    String? address,
    String? licenseNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/account/register/provider/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'institution_name': institutionName,
        'email': email,
        'phone': phone,
        'admin_username': adminUsername,
        'admin_password': adminPassword,
        'address': address,
        'license_number': licenseNumber,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      return data;
    } else {
      throw AuthException(data['detail'] ?? 'Provider registration failed');
    }
  }

  /// Fetches the current user's profile information
  Future<Map<String, dynamic>> getProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/me/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return data;
    } else {
      throw AuthException(data['detail'] ?? 'Failed to fetch profile');
    }
  }
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
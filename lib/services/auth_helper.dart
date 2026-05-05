import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthHelper {
  static final _supabase = Supabase.instance.client;

  /// LOGIN
  static Future<void> login({
    required String email,
    required String password,
  }) async {

    // print(email);
    // print(password);

    // final res = await _supabase.auth.signInWithPassword(
    //   email: email,
    //   password: password,
    // );

    // print('Login response: $res');

    // print(token);

    // if (res.session == null) {
    //   throw Exception('Login gagal');
    // }

    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // print('Login response: $res');
      // print('Session: ${res.session}');

      if (res.session == null) {
        throw Exception('Login gagal');
      }
    } catch (e) {
      print('Login ERROR: $e');
      rethrow; // Still throw to the calling function
    }
  }

  /// REGISTER
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (res.user == null) {
      throw Exception('Register gagal');
    }
  }

  /// GET JWT TOKEN
  static String? get token =>
      _supabase.auth.currentSession?.accessToken;

  /// CURRENT USER
  static User? get currentUser => _supabase.auth.currentUser;

  /// CALL BACKEND (auth/ping)
  static Future<void> testPing() async {
    final t = token;

    if (t == null) {
      throw Exception('Token null, user belum login');
    }

    final baseUrl = dotenv.env['API_BASE_URL']!;

    final res = await http.get(
      Uri.parse('$baseUrl/auth/ping'),
      headers: {
        'Authorization': 'Bearer $t',
      },
    );

    print('Status: ${res.statusCode}');
    print('Body: ${res.body}');
  }

  /// LOGOUT
  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthHelper {
  static final _supabase = Supabase.instance.client;

  /// LOGIN with email and password
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session == null) {
        throw Exception('Login gagal');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// REGISTER with email, password, and user metadata
  static Future<void> register({
    required String email,
    required String password,
    String? username,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          if (username != null) 'username': username,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (firstName != null && lastName != null)
            'full_name': '$firstName $lastName',
        },
      );

      if (res.user == null) {
        throw Exception('Register gagal');
      }
    } catch (e) {
      rethrow;
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

    await http.get(
      Uri.parse('$baseUrl/auth/ping'),
      headers: {
        'Authorization': 'Bearer $t',
      },
    );
  }

  /// LOGOUT
  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  /// Parse Supabase error messages to user-friendly messages
  static String parseError(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('User already registered')) {
      return 'Email sudah terdaftar. Gunakan email lain atau login.';
    } else if (errorString.contains('Invalid login credentials')) {
      return 'Email atau password salah.';
    } else if (errorString.contains('Email not confirmed')) {
      return 'Email belum dikonfirmasi. Periksa email Anda.';
    } else if (errorString.contains('weak_password')) {
      return 'Password terlalu lemah. Gunakan kombinasi karakter yang lebih kuat.';
    } else if (errorString.contains('Over request rate limit')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    } else if (errorString.contains('already')) {
      return 'Email sudah terdaftar.';
    }
    return errorString;
  }
}
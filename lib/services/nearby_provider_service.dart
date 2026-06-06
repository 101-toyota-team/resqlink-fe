import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NearbyProviderService {
  Future<dynamic> getNearbyProviders(
    String token, {
    required String h3Index,
    required double latitude,
    required double longitude,
  }) async {
    try {

      // Hit API
      final response = await http.get(
        Uri.parse(
          '${dotenv.env['API_BASE_URL']}/providers/nearby?h3_index=$h3Index&lat=$latitude&lng=$longitude',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch nearby providers: ${response.statusCode} - ${response.body}',
        );
      }

      if (response.body.isEmpty) {
        return []; // Return empty list for empty response
      }

      final decoded = jsonDecode(response.body);
      
      // If the response is a string that needs parsing again
      if (decoded is String) {
        return jsonDecode(decoded);
      }
      
      return decoded;
      
    } catch (e) {
      rethrow;
    }
  }
}
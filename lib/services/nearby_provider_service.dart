import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'location_service.dart';
import 'h3_helper.dart';

class NearbyProviderService {
  final LocationService _locationService =
      LocationService();

  final H3Helper _h3Helper = H3Helper();

  Future<dynamic> getNearbyProviders(String token) async {
    try {
      // ambil lokasi user
      final position = await _locationService.getUserLocation();
      
      print('📍 User location: ${position.latitude}, ${position.longitude}');

      // generate h3 index
      final h3Index = await H3Helper.generateH3Index(
        position.latitude,
        position.longitude,
      );
      
      print('🔢 H3 Index: $h3Index');

      // hit API
      final response = await http.get(
        Uri.parse(
          '${dotenv.env['API_BASE_URL']}/providers/nearby?h3_index=878c10702ffffff&lat=${position.latitude}&lng=${position.longitude}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

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
      print('❌ Service error: $e');
      rethrow;
    }
  }
}
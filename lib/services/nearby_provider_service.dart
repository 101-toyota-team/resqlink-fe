import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'location_service.dart';
import 'h3_helper.dart';

class NearbyProviderService {
  final LocationService _locationService =
      LocationService();

  final H3Helper _h3Helper = H3Helper();

  Future<dynamic> getNearbyProviders(
    String token,
  ) async {
    // ambil lokasi user
    final position =
        await _locationService.getUserLocation();

    // generate h3 index
    final h3Index = _h3Helper.generateH3Index(
      position.latitude,
      position.longitude,
    );

    // hit API
    final response = await http.get(
      Uri.parse(
        '${dotenv.env['API_BASE_URL']}/providers/nearby?h3_index=$h3Index',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch nearby providers',
      );
    }

    return jsonDecode(response.body);
  }
}
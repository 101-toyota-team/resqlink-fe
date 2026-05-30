import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookingService {
  static String get _baseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null) {
      throw Exception('API_BASE_URL not found in .env file');
    }
    return url;
  }
  
  /// Create a new booking
  static Future<Map<String, dynamic>> createBooking({
    required String token,
    required String providerId,
    required String bookingType,
    required String patientCondition,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String pickupH3,
    required String destinationAddress,
    required double destinationLat,
    required double destinationLng,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/bookings');
      
      final body = {
        'provider_id': providerId,
        'booking_type': bookingType,
        'patient_condition': patientCondition,
        'pickup_address': pickupAddress,
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'pickup_h3': pickupH3,
        'destination_address': destinationAddress,
        'destination_lat': destinationLat,
        'destination_lng': destinationLng,
      };
      
      print('POST to: $url');
      print('Body: $body');
      
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create booking: ${response.statusCode} - ${response.body}');
      }
      
    } catch (e) {
      print('❌ Booking error: $e');
      rethrow;
    }
  }
}
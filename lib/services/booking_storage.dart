import 'package:shared_preferences/shared_preferences.dart';

class BookingStorage {
  static const String _activeBookingIdKey = 'active_booking_id';
  static const String _activeBookingDataKey = 'active_booking_data';

  static Future<void> saveActiveBooking(String bookingId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeBookingIdKey, bookingId);
    // You could also save the whole JSON if needed
  }

  static Future<String?> getActiveBookingId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeBookingIdKey);
  }

  static Future<void> clearActiveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeBookingIdKey);
    await prefs.remove(_activeBookingDataKey);
  }
}

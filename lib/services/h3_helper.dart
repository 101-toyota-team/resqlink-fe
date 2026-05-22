import 'package:h3_flutter/h3_flutter.dart';

class H3Helper {
  static H3? _h3;
  static bool _isInitialized = false;

  // Initialize H3 (call this once in main.dart)
  static Future<void> init() async {
    if (!_isInitialized) {
      _h3 = await const H3Factory().load();
      _isInitialized = true;
      print('✅ H3 initialized successfully');
    }
  }

  // Ensure H3 is initialized before using
  static Future<H3> get _h3Instance async {
    if (!_isInitialized) {
      await init();
    }
    return _h3!;
  }

  static Future<String> generateH3Index(
    double latitude,
    double longitude,
  ) async {
    try {
      final h3 = await _h3Instance;
      final h3Index = h3.geoToCell(
        GeoCoord(
          lat: latitude,
          lon: longitude,
        ),
        9,
      );
      return h3Index.toRadixString(16);
    } catch (e) {
      print('❌ Error generating H3 index: $e');
      rethrow;
    }
  }
}

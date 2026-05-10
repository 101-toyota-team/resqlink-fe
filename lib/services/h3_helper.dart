import 'package:h3_flutter/h3_flutter.dart';

class H3Helper {
  static final H3 _h3 =
      const H3Factory().load();

  static String generateH3Index(
    double latitude,
    double longitude,
  ) {
    final h3Index = _h3.geoToCell(
      GeoCoord(
        lat: latitude,
        lon: longitude,
      ),
      9,
    );

    return h3Index.toRadixString(16);
  }
}
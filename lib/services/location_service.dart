import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _cachedPosition;

  final Position _dummyPosition = Position(
    latitude: -6.2088,  // Jakarta latitude
    longitude: 106.8456, // Jakarta longitude
    timestamp: DateTime.now(),
    accuracy: 100,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  Future<Position> getUserLocation() async {
    // pakai cache kalau ada
    if (_cachedPosition != null) {
      return _cachedPosition!;
    }

    // check permission sekali
    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    // coba ambil lokasi terakhir dulu
    Position? lastPosition =
        await Geolocator.getLastKnownPosition();

    // Position? lastPosition = _dummyPosition;

    if (lastPosition != null) {
      _cachedPosition = lastPosition;

      // refresh di background
      _refreshLocation();

      return lastPosition;
    }

    // fallback GPS fresh request
    final position =
        await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    _cachedPosition = position;

    return position;
  }

  Future<void> _refreshLocation() async {
    try {
      final freshPosition =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _cachedPosition = freshPosition;
    } catch (_) {}
  }
}
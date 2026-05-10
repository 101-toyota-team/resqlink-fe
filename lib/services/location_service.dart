import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _cachedPosition;

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
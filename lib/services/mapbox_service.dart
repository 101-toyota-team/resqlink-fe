import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MapboxService {
  static final String accessToken = dotenv.env['MAPBOX_TOKEN']!;


  static Future<List<LatLng>> getRoute() async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '106.816666,-6.200000;'
        '107.609810,-6.914744'
        '?geometries=polyline'
        '&overview=full'
        '&access_token=$accessToken';

    final response = await http.get(
      Uri.parse(url),
    );

    final data = jsonDecode(response.body);

    final encoded =
        data['routes'][0]['geometry'];

    PolylinePoints polylinePoints =
        PolylinePoints();

    List<PointLatLng> points =
        polylinePoints.decodePolyline(
          encoded,
        );

    return points
        .map(
          (p) => LatLng(
            p.latitude,
            p.longitude,
          ),
        )
        .toList();
  }
}
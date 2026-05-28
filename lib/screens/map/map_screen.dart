import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/map_helper.dart';
import '../../services/mapbox_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState
    extends State<MapScreen> {
  GoogleMapController? _mapController;

  Set<Polyline> _polylines = {};

  List<LatLng> routePoints = [];

  Future<void> loadRoute() async {
    routePoints =
        await MapboxService.getRoute();

    final polyline = Polyline(
      polylineId: const PolylineId(
        'route',
      ),
      points: routePoints,
      width: 5,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  Future<void> _onMapCreated(
    GoogleMapController controller,
  ) async {
    _mapController = controller;

    await loadRoute();

    if (routePoints.isNotEmpty) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          boundsFromLatLngList(
            routePoints,
          ),
          50,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        borderRadius:
            BorderRadius.circular(10),
        child: GoogleMap(
          onMapCreated: _onMapCreated,

          initialCameraPosition:
              const CameraPosition(
            target: LatLng(
              -6.200000,
              106.816666,
            ),
            zoom: 12,
          ),

          polylines: _polylines,

          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: true,
        ),
      ),
    );
  }
}
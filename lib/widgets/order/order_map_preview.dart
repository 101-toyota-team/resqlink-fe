import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../screens/order/pilih_tujuan.dart';
import '../../schema/location.dart';
import 'location_selector.dart';

class OrderMapPreview extends StatefulWidget {
  final Function(LocationData pickup, LocationData destination)? onLocationChanged; // Legacy, optional

  const OrderMapPreview({
    Key? key,
    this.onLocationChanged,
  }) : super(key: key);

  @override
  State<OrderMapPreview> createState() => _OrderMapPreviewState();
}

class _OrderMapPreviewState extends State<OrderMapPreview> {
  MapboxMap? _mapboxMap;
  
  // Simpan LocationData lengkap
  LocationData _pickupData = LocationData(
    address: "",
    latitude: 0.0,
    longitude: 0.0,
  );
  LocationData _destinationData = LocationData(
    address: "",
    latitude: 0.0,
    longitude: 0.0,
  );

  @override
  void initState() {
    super.initState();
    String accessToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    MapboxOptions.setAccessToken(accessToken);
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
  }

  void _navigateToSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDestinationScreen(
          initialPickup: _pickupData,
          initialDestination: _destinationData,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      // Ambil LocationData dari result
      final pickupData = result['pickup'] as LocationData;
      final destinationData = result['destination'] as LocationData;
      
      setState(() {
        // Simpan LocationData lengkap
        _pickupData = pickupData;
        _destinationData = destinationData;
      });
      
      // Legacy callback (optional)
      widget.onLocationChanged?.call(_pickupData, _destinationData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToSelection,
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Mapbox Core View Engine
              AbsorbPointer(
                absorbing: true,
                child: MapWidget(
                  key: const ValueKey("miniMapboxWidget"),
                  onMapCreated: _onMapCreated,
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  cameraOptions: CameraOptions(
                    center: Point(coordinates: Position(106.816666, -6.200000)),
                    zoom: 14.0,
                  ),
                ),
              ),

              // Gradient Scrim Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white.withOpacity(0.95),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Location Selector Overlay Float (READ-ONLY MODE)
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: AbsorbPointer(
                  absorbing: true, // Keep this true for read-only preview
                  child: LocationSelector(
                    initialPickup: _pickupData.address,
                    initialDestination: _destinationData.address,
                    isReadOnly: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:ui' as ui; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/gestures.dart';  
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import '../../services/auth_helper.dart'; 
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../widgets/tracking/travel_status.dart';
import '../../widgets/tracking/eta_info.dart';
import '../../widgets/tracking/driver_section.dart';

class TrackingScreen extends StatefulWidget {
  final String bookingId; 

  const TrackingScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager; 
  
  PointAnnotation? _ambulanceAnnotation;
  PolylineAnnotation? _bluePolyline; 
  PolylineAnnotation? _grayPolyline; 

  Timer? _pollingTimer; 
  
  Position? _currentDriverPosition;
  Position? _pickupPosition;
  Position? _destinationPosition;
  String _bookingStatusStr = "draft";
  int _currentTravelStatus = 0; 

  String _liveEtaText = "-- mins";
  String _liveDistanceText = "-- km";

  @override
  void initState() {
    super.initState();
    String accessToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    MapboxOptions.setAccessToken(accessToken);
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); 
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));

    _polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
    _pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    
    await _generateAndRegisterCanvasIcons(mapboxMap);
    _startLiveTrackingPolling();
  }

  void _startLiveTrackingPolling() {
    _fetchTrackingData(); 
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchTrackingData();
    });
  }

  Future<void> _fetchTrackingData() async {
    final String? jwtToken = AuthHelper.token;
    if (jwtToken == null) return;

    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "http://localhost:3000";
    final url = Uri.parse("$baseUrl/bookings/${widget.bookingId}");

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final double pLat = data['pickup_lat'];
        final double pLng = data['pickup_lng'];
        final double dLat = data['destination_lat'];
        final double dLng = data['destination_lng'];
        
        _bookingStatusStr = data['status']; 

        double currentLat = pLat;
        double currentLng = pLng;
        String etaText = "-- mins";
        String distanceText = "-- km";

        if (data['ambulance'] != null) {
          final ambulance = data['ambulance'];
          currentLat = ambulance['lat'] ?? pLat;
          currentLng = ambulance['lng'] ?? pLng;
          if (ambulance['eta'] != null) etaText = ambulance['eta'];
          if (ambulance['distance'] != null) distanceText = ambulance['distance'];
        }

        int mappedStatusInt = 0;
        if (_bookingStatusStr == "arrived") {
          mappedStatusInt = 1; 
        } else if (_bookingStatusStr == "to_hospital") {
          mappedStatusInt = 2; 
        } else if (_bookingStatusStr == "completed") {
          mappedStatusInt = 3; 
        }

        if (mounted) {
          setState(() {
            _pickupPosition = Position(pLng, pLat);
            _destinationPosition = Position(dLng, dLat);
            _currentDriverPosition = Position(currentLng, currentLat);
            _currentTravelStatus = mappedStatusInt;
            _liveEtaText = etaText;
            _liveDistanceText = distanceText;
          });
        }

        _drawStaticLocationMarkers(_pointAnnotationManager);
        _updateLiveRouteLinesAndMarker();
      }
    } catch (e) {
      debugPrint("Gagal sinkronisasi API: $e");
    }
  }

  void _updateLiveRouteLinesAndMarker() async {
    if (_polylineAnnotationManager == null || _currentDriverPosition == null) return;

    if (_bluePolyline != null) await _polylineAnnotationManager?.delete(_bluePolyline!);
    if (_grayPolyline != null) await _polylineAnnotationManager?.delete(_grayPolyline!);

    if (_bookingStatusStr == "draft" || _bookingStatusStr == "confirmed" || _bookingStatusStr == "en_route") {
      _bluePolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_currentDriverPosition!, _pickupPosition!]),
          lineColor: AppColors.primary.toARGB32(), 
          lineWidth: 6.0,
        ),
      );
      _grayPolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_pickupPosition!, _destinationPosition!]),
          lineColor: AppColors.primary.withOpacity(0.3).toARGB32(),
          lineWidth: 6.0,
        ),
      );
    } 
    else {
      _bluePolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_pickupPosition!, _currentDriverPosition!]),
          lineColor: Colors.grey.shade400.toARGB32(),
          lineWidth: 5.0,
        ),
      );
      _grayPolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_currentDriverPosition!, _destinationPosition!]),
          lineColor: AppColors.primary.toARGB32(), 
          lineWidth: 6.0,
        ),
      );
    }

    if (_pointAnnotationManager != null) {
      if (_ambulanceAnnotation == null) {
        _ambulanceAnnotation = await _pointAnnotationManager?.create(
          PointAnnotationOptions(
            geometry: Point(coordinates: _currentDriverPosition!),
            iconImage: "ambulance-icon",
            iconSize: 0.4,
          ),
        );
      } else {
        _ambulanceAnnotation?.geometry = Point(coordinates: _currentDriverPosition!);
        _pointAnnotationManager?.update(_ambulanceAnnotation!);
      }
    }

    _mapboxMap?.flyTo(
      CameraOptions(center: Point(coordinates: _currentDriverPosition!), zoom: 15.5),
      MapAnimationOptions(duration: 1200),
    );
  }

  void _drawStaticLocationMarkers(PointAnnotationManager? manager) async {
    if (manager == null || _pickupPosition == null || _destinationPosition == null) return;
    await manager.deleteAll();
    _ambulanceAnnotation = null; 
    await manager.create(PointAnnotationOptions(geometry: Point(coordinates: _pickupPosition!), iconImage: "patient-icon", iconSize: 0.35));
    await manager.create(PointAnnotationOptions(geometry: Point(coordinates: _destinationPosition!), iconImage: "hospital-icon", iconSize: 0.35));
  }

  Future<void> _generateAndRegisterCanvasIcons(MapboxMap targetMap) async {
    final iconsToDraw = [
      {"id": "ambulance-icon", "color": AppColors.primary, "icon": Icons.airport_shuttle_rounded}, 
      {"id": "patient-icon", "color": AppColors.ambulanceJenazah, "icon": Icons.person_pin_circle_rounded},
      {"id": "hospital-icon", "color": Colors.blue, "icon": Icons.local_hospital_rounded}
    ];

    for (var target in iconsToDraw) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 100, 100));
      canvas.drawCircle(const Offset(50, 50), 45, Paint()..color = Colors.white);
      canvas.drawCircle(const Offset(50, 50), 45, Paint()..color = target["color"] as Color..style = PaintingStyle.stroke..strokeWidth = 8);

      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode((target["icon"] as IconData).codePoint),
        style: TextStyle(fontSize: 55, fontFamily: (target["icon"] as IconData).fontFamily, color: target["color"] as Color),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(50 - textPainter.width / 2, 50 - textPainter.height / 2));

      final img = await recorder.endRecording().toImage(100, 100);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        await targetMap.style.addStyleImage(target["id"] as String, 1.0, MbxImage(width: 100, height: 100, data: byteData.buffer.asUint8List()), false, [], [], null);
      }
    }
  }

  void _showFullMapPreview(BuildContext context) {
    if (_currentDriverPosition == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85, 
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: MapWidget(
                key: const ValueKey("fullScreenMap"),
                styleUri: MapboxStyles.MAPBOX_STREETS,
                viewport: CameraViewportState(center: Point(coordinates: _currentDriverPosition!), zoom: 15.5),
                gestureRecognizers: { Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()) },
                onMapCreated: (fullMap) async {
                  fullMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                  fullMap.compass.updateSettings(CompassSettings(enabled: false));
                  await _generateAndRegisterCanvasIcons(fullMap);
                  final polylineManager = await fullMap.annotations.createPolylineAnnotationManager();
                  final pointManager = await fullMap.annotations.createPointAnnotationManager();
                  
                  final routeColor = AppColors.primary.toARGB32();
                  if (_bookingStatusStr == "draft" || _bookingStatusStr == "confirmed" || _bookingStatusStr == "en_route") {
                    await polylineManager.create(PolylineAnnotationOptions(geometry: LineString(coordinates: [_currentDriverPosition!, _pickupPosition!]), lineColor: routeColor, lineWidth: 7.0));
                    await polylineManager.create(PolylineAnnotationOptions(geometry: LineString(coordinates: [_pickupPosition!, _destinationPosition!]), lineColor: AppColors.primary.withOpacity(0.3).toARGB32(), lineWidth: 7.0));
                  } else {
                    await polylineManager.create(PolylineAnnotationOptions(geometry: LineString(coordinates: [_pickupPosition!, _currentDriverPosition!]), lineColor: Colors.grey.shade400.toARGB32(), lineWidth: 6.0));
                    await polylineManager.create(PolylineAnnotationOptions(geometry: LineString(coordinates: [_currentDriverPosition!, _destinationPosition!]), lineColor: routeColor, lineWidth: 7.0));
                  }
                  
                  _drawStaticLocationMarkers(pointManager);
                  await pointManager.create(PointAnnotationOptions(geometry: Point(coordinates: _currentDriverPosition!), iconImage: "ambulance-icon", iconSize: 0.4));
                },
              ),
            ),
            Positioned(top: 20, right: 20, child: FloatingActionButton.small(onPressed: () => Navigator.pop(context), backgroundColor: Colors.white, child: const Icon(Icons.close_rounded, color: AppColors.textDark))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Status Perjalanan", style: AppTypography.title.copyWith(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Opacity(opacity: 0.05, child: Image.asset('assets/images/medic_pattern.png', fit: BoxFit.cover))),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            child: Column(
              children: [
                TravelStatusWidget(currentStatus: _currentTravelStatus),
                const SizedBox(height: 20),
                
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: MapWidget(
                          key: const ValueKey("trackingMap"),
                          styleUri: MapboxStyles.MAPBOX_STREETS,
                          viewport: CameraViewportState(center: Point(coordinates: Position(106.819543, -6.215124)), zoom: 14.5),
                          onMapCreated: _onMapCreated,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton.icon(
                          onPressed: () => _showFullMapPreview(context),
                          icon: const Icon(Icons.fullscreen_rounded, size: 18),
                          label: const Text("Perbesar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 8,
                            shadowColor: Colors.black26,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            textStyle: AppTypography.captionSmall.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                EtaInfoWidget(eta: _liveEtaText, distance: _liveDistanceText),
                const SizedBox(height: 20),
                const DriverSectionWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
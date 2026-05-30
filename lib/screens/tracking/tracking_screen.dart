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
  
  // State Lokasi Real-time
  Position? _currentDriverPosition;
  Position? _pickupPosition;
  Position? _destinationPosition;
  String _bookingStatusStr = "draft";
  int _currentTravelStatus = 0; 

  // State Telemetri Live (AmbulanceDetails)
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

  // MENGONSUMSI ENDPOINT GET /bookings/{id} SECARA LIVE
  Future<void> _fetchTrackingData() async {
    final String? jwtToken = AuthHelper.token;
    if (jwtToken == null) {
      debugPrint("Gagal mengambil data tracking: Token null.");
      return;
    }

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

        // IMPLEMENTASI SKEMA AMBULANCEDETAILS KANAN & KIRI
        if (data['ambulance'] != null) {
          final ambulance = data['ambulance'];
          
          // 1. Ambil koordinat live telemetri (dari properti AmbulanceLocation)
          currentLat = ambulance['lat'] ?? pLat;
          currentLng = ambulance['lng'] ?? pLng;
          
          // 2. Ambil string ETA & Jarak dinamis dari server
          if (ambulance['eta'] != null) {
            etaText = ambulance['eta'];
          }
          if (ambulance['distance'] != null) {
            distanceText = ambulance['distance'];
          }
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
      debugPrint("Gagal sinkronisasi dengan ResQLink API: $e");
    }
  }

  void _updateLiveRouteLinesAndMarker() async {
    if (_polylineAnnotationManager == null || _currentDriverPosition == null) return;

    if (_bluePolyline != null) await _polylineAnnotationManager?.delete(_bluePolyline!);
    if (_grayPolyline != null) await _polylineAnnotationManager?.delete(_grayPolyline!);

    // FASE JEMPUT: (status: draft, confirmed, en_route)
    if (_bookingStatusStr == "draft" || _bookingStatusStr == "confirmed" || _bookingStatusStr == "en_route") {
      List<Position> pickupSegment = [_currentDriverPosition!, _pickupPosition!];
      _bluePolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: pickupSegment),
          lineColor: const Color(0xFF00A2E8).toARGB32(), 
          lineWidth: 6.0,
        ),
      );

      List<Position> hospitalSegment = [_pickupPosition!, _destinationPosition!];
      _grayPolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: hospitalSegment),
          lineColor: const Color(0xFF00A2E8).toARGB32(),
          lineWidth: 6.0,
        ),
      );
    } 
    // FASE MENUJU RS / SAMPAI: (status: arrived, to_hospital, completed)
    else {
      List<Position> passedPath = [_pickupPosition!, _currentDriverPosition!];
      _bluePolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: passedPath),
          lineColor: Colors.grey[400]!.toARGB32(),
          lineWidth: 5.0,
        ),
      );

      List<Position> remainingPath = _currentDriverPosition! == _destinationPosition! 
          ? [_currentDriverPosition!, _currentDriverPosition!]
          : [_currentDriverPosition!, _destinationPosition!];
          
      _grayPolyline = await _polylineAnnotationManager?.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: remainingPath),
          lineColor: const Color(0xFF00A2E8).toARGB32(), 
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

    await manager.create(PointAnnotationOptions(
      geometry: Point(coordinates: _pickupPosition!),
      iconImage: "patient-icon",
      iconSize: 0.35,
    ));

    await manager.create(PointAnnotationOptions(
      geometry: Point(coordinates: _destinationPosition!),
      iconImage: "hospital-icon",
      iconSize: 0.35,
    ));
  }

  Future<void> _generateAndRegisterCanvasIcons(MapboxMap targetMap) async {
    final iconsToDraw = [
      {"id": "ambulance-icon", "color": Colors.red, "icon": Icons.airport_shuttle}, 
      {"id": "patient-icon", "color": Colors.green, "icon": Icons.person_pin_circle},
      {"id": "hospital-icon", "color": Colors.blueAccent, "icon": Icons.local_hospital}
    ];

    for (var target in iconsToDraw) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 100, 100));
      final bgPaint = Paint()..color = Colors.white;
      canvas.drawCircle(const Offset(50, 50), 45, bgPaint);
      
      final borderPaint = Paint()
        ..color = target["color"] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawCircle(const Offset(50, 50), 45, borderPaint);

      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode((target["icon"] as IconData).codePoint),
        style: TextStyle(
          fontSize: 55,
          fontFamily: (target["icon"] as IconData).fontFamily,
          color: target["color"] as Color,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(50 - textPainter.width / 2, 50 - textPainter.height / 2));

      final picture = recorder.endRecording();
      final img = await picture.toImage(100, 100);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        await targetMap.style.addStyleImage(
          target["id"] as String, 
          1.0, 
          MbxImage(width: 100, height: 100, data: byteData.buffer.asUint8List()), 
          false, [], [], null
        );
      }
    }
  }

  void _showFullMapPreview(BuildContext context) {
    if (_currentDriverPosition == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9, 
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: MapWidget(
                  key: const ValueKey("fullScreenMapboxWidget"),
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  viewport: CameraViewportState(
                    center: Point(coordinates: _currentDriverPosition!), 
                    zoom: 15.5, 
                  ),
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                  },
                  onMapCreated: (fullMapboxMap) async {
                    fullMapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                    fullMapboxMap.compass.updateSettings(CompassSettings(enabled: false));

                    await _generateAndRegisterCanvasIcons(fullMapboxMap);
                    final polylineManager = await fullMapboxMap.annotations.createPolylineAnnotationManager();
                    
                    if (_bookingStatusStr == "draft" || _bookingStatusStr == "confirmed" || _bookingStatusStr == "en_route") {
                      await polylineManager.create(PolylineAnnotationOptions(
                        geometry: LineString(coordinates: [_currentDriverPosition!, _pickupPosition!]),
                        lineColor: const Color(0xFF00A2E8).toARGB32(),
                        lineWidth: 7.0,
                      ));
                      await polylineManager.create(PolylineAnnotationOptions(
                        geometry: LineString(coordinates: [_pickupPosition!, _destinationPosition!]),
                        lineColor: const Color(0xFF00A2E8).toARGB32(),
                        lineWidth: 7.0,
                      ));
                    } else {
                      await polylineManager.create(PolylineAnnotationOptions(
                        geometry: LineString(coordinates: [_pickupPosition!, _currentDriverPosition!]),
                        lineColor: Colors.grey[400]!.toARGB32(),
                        lineWidth: 6.0,
                      ));
                      await polylineManager.create(PolylineAnnotationOptions(
                        geometry: LineString(coordinates: [_currentDriverPosition!, _destinationPosition!]),
                        lineColor: const Color(0xFF00A2E8).toARGB32(),
                        lineWidth: 7.0,
                      ));
                    }

                    final pointManager = await fullMapboxMap.annotations.createPointAnnotationManager();
                    _drawStaticLocationMarkers(pointManager);

                    await pointManager.create(PointAnnotationOptions(
                      geometry: Point(coordinates: _currentDriverPosition!),
                      iconImage: "ambulance-icon",
                      iconSize: 0.4,
                    ));
                  },
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                    ),
                    child: const Icon(Icons.close, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Status Perjalanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TravelStatusWidget(currentStatus: _currentTravelStatus),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Stack(
                clipBehavior: Clip.none, 
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: MapWidget(
                          key: const ValueKey("trackingMapboxWidget"),
                          styleUri: MapboxStyles.MAPBOX_STREETS,
                          viewport: CameraViewportState(
                            center: Point(coordinates: Position(106.819543, -6.215124)), 
                            zoom: 14.5,
                          ),
                          onMapCreated: _onMapCreated,
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showFullMapPreview(context),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.fullscreen, color: Color(0xFF9E5C11), size: 20),
                              SizedBox(width: 6),
                              Text(
                                "Perbesar",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9E5C11)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            // SINKRONISASI PARAMETER BARU UNTUK SEKSI ETA & JARAK LIVE DARI SERVER
            EtaInfoWidget(
              eta: _liveEtaText,
              distance: _liveDistanceText,
            ),
            const SizedBox(height: 20),
            const DriverSectionWidget(),
          ],
        ),
      ),
    );
  }
}
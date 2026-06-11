import 'dart:async';
import 'dart:ui' as ui; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/gestures.dart';  
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_helper.dart'; 
import '../../services/booking_service.dart';
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
  // --- Peta Utama (Kecil) ---
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager; 
  PointAnnotation? _ambulanceAnnotation;
  PolylineAnnotation? _bluePolyline; 
  PolylineAnnotation? _grayPolyline; 

  // --- Peta Modal (Full Screen Preview) ---
  MapboxMap? _fullMapboxMap;
  PointAnnotationManager? _fullPointAnnotationManager;
  PolylineAnnotationManager? _fullPolylineAnnotationManager;
  PointAnnotation? _fullAmbulanceAnnotation;
  PolylineAnnotation? _fullBluePolyline; 
  PolylineAnnotation? _fullGrayPolyline;

  Timer? _pollingTimer; 
  RealtimeChannel? _realtimeChannel;
  
  Position? _currentDriverPosition;
  Position? _pickupPosition;
  Position? _destinationPosition;
  String _bookingStatusStr = "draft";
  int _currentTravelStatus = 0; 

  String _liveEtaText = "-- menit";
  String _liveDistanceText = "-- km";

  @override
  void initState() {
    super.initState();
    debugPrint('🔵 [INIT] TrackingScreen initialized for booking: ${widget.bookingId}');
    String accessToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    MapboxOptions.setAccessToken(accessToken);
  }

  @override
  void dispose() {
    debugPrint('🔵 [DISPOSE] Cleaning up tracking screen');
    _pollingTimer?.cancel();
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    debugPrint('🔵 [MAP] Main Map created');
    _mapboxMap = mapboxMap;
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));

    _polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
    _pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    
    await _generateAndRegisterCanvasIcons(mapboxMap);
    
    _subscribeToRealtimeLocation();
    _startLiveTrackingPolling();

    _mapboxMap?.setCamera(
      CameraOptions(
        center: Point(coordinates: _currentDriverPosition ?? Position(106.816666, -6.200000)),
        zoom: 12.0,
        bearing: 0.0,
        pitch: 0.0,
      ),
    );
  }

  void _subscribeToRealtimeLocation() {
    debugPrint('🔵 [REALTIME] Step 1/5: Starting realtime subscription...');
    final supabase = Supabase.instance.client;
    final channelName = 'trip:${widget.bookingId}';
    
    _realtimeChannel = supabase
        .channel(channelName)
        .onBroadcast(
          event: 'location_update',
          callback: (payload) {
            try {
              final broadcastPayload = payload['payload'];
              if (broadcastPayload == null) return;
              
              final lat = broadcastPayload['lat'];
              final lng = broadcastPayload['lng'];
              
              double? parsedLat;
              double? parsedLng;
              
              if (lat is num) parsedLat = lat.toDouble();
              if (lat is String) parsedLat = double.tryParse(lat);
              if (lng is num) parsedLng = lng.toDouble();
              if (lng is String) parsedLng = double.tryParse(lng);
              
              if (parsedLat != null && parsedLng != null && mounted) {
                final newPosition = Position(parsedLng, parsedLat);
                
                setState(() {
                  _currentDriverPosition = newPosition;
                });
                
                // 1. Update Komponen Peta Utama
                _updateAmbulanceMarkerOnly(newPosition, isFullScreenMap: false);
                _updateRouteLines(isFullScreenMap: false);
                
                // 2. Update Komponen Peta Modal (Jika Sedang Terbuka)
                if (_fullMapboxMap != null) {
                  _updateAmbulanceMarkerOnly(newPosition, isFullScreenMap: true);
                  _updateRouteLines(isFullScreenMap: true);
                }
              }
            } catch (e) {
              debugPrint('🔴 [REALTIME ERROR] Exception in broadcast callback: $e');
            }
          },
        )
        .subscribe();
  }

  void _updateAmbulanceMarkerOnly(Position newPosition, {required bool isFullScreenMap}) async {
    if (!isFullScreenMap) {
      if (_pointAnnotationManager == null) return;
      if (_ambulanceAnnotation == null) {
        _ambulanceAnnotation = await _pointAnnotationManager?.create(
          PointAnnotationOptions(
            geometry: Point(coordinates: newPosition),
            iconImage: "ambulance-icon",
            iconSize: 0.4,
          ),
        );
      } else {
        _ambulanceAnnotation?.geometry = Point(coordinates: newPosition);
        _pointAnnotationManager?.update(_ambulanceAnnotation!);
      }
    } else {
      if (_fullPointAnnotationManager == null) return;
      if (_fullAmbulanceAnnotation == null) {
        _fullAmbulanceAnnotation = await _fullPointAnnotationManager?.create(
          PointAnnotationOptions(
            geometry: Point(coordinates: newPosition),
            iconImage: "ambulance-icon",
            iconSize: 0.4,
          ),
        );
      } else {
        _fullAmbulanceAnnotation?.geometry = Point(coordinates: newPosition);
        _fullPointAnnotationManager?.update(_fullAmbulanceAnnotation!);
      }
    }
  }

  void _updateRouteLines({required bool isFullScreenMap}) async {
    if (_currentDriverPosition == null || _pickupPosition == null || _destinationPosition == null) return;

    final isDraftOrConfirmed = _bookingStatusStr == "draft" || _bookingStatusStr == "confirmed" || _bookingStatusStr == "en_route";

    if (!isFullScreenMap) {
      if (_polylineAnnotationManager == null) return;
      if (_bluePolyline != null) await _polylineAnnotationManager?.delete(_bluePolyline!);
      if (_grayPolyline != null) await _polylineAnnotationManager?.delete(_grayPolyline!);

      if (isDraftOrConfirmed) {
        _bluePolyline = await _polylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_currentDriverPosition!, _pickupPosition!]),
          lineColor: AppColors.primary.toARGB32(), lineWidth: 6.0,
        ));
        _grayPolyline = await _polylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_pickupPosition!, _destinationPosition!]),
          lineColor: AppColors.primary.withValues(alpha: 0.3).toARGB32(), lineWidth: 6.0,
        ));
      } else {
        _bluePolyline = await _polylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_pickupPosition!, _currentDriverPosition!]),
          lineColor: Colors.grey.shade400.toARGB32(), lineWidth: 5.0,
        ));
        _grayPolyline = await _polylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_currentDriverPosition!, _destinationPosition!]),
          lineColor: AppColors.primary.toARGB32(), lineWidth: 6.0,
        ));
      }
    } else {
      if (_fullPolylineAnnotationManager == null) return;
      if (_fullBluePolyline != null) await _fullPolylineAnnotationManager?.delete(_fullBluePolyline!);
      if (_fullGrayPolyline != null) await _fullPolylineAnnotationManager?.delete(_fullGrayPolyline!);

      if (isDraftOrConfirmed) {
        _fullBluePolyline = await _fullPolylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_currentDriverPosition!, _pickupPosition!]),
          lineColor: AppColors.primary.toARGB32(), lineWidth: 7.0,
        ));
        _fullGrayPolyline = await _fullPolylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_pickupPosition!, _destinationPosition!]),
          lineColor: AppColors.primary.withValues(alpha: 0.3).toARGB32(), lineWidth: 7.0,
        ));
      } else {
        _fullBluePolyline = await _fullPolylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_pickupPosition!, _currentDriverPosition!]),
          lineColor: Colors.grey.shade400.toARGB32(), lineWidth: 6.0,
        ));
        _fullGrayPolyline = await _fullPolylineAnnotationManager?.create(PolylineAnnotationOptions(
          geometry: LineString(coordinates: [_currentDriverPosition!, _destinationPosition!]),
          lineColor: AppColors.primary.toARGB32(), lineWidth: 7.0,
        ));
      }
    }
  }

  void _startLiveTrackingPolling() {
    _fetchTrackingData(); 
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchTrackingData();
    });
  }

  Future<void> _fetchTrackingData() async {
    final String? jwtToken = AuthHelper.token;
    if (jwtToken == null) return;

    try {
      final data = await BookingService.getBookingDetails(widget.bookingId, jwtToken);
      
      final double pLat = data['pickup_lat'];
      final double pLng = data['pickup_lng'];
      final double dLat = data['destination_lat'];
      final double dLng = data['destination_lng'];
      
      _bookingStatusStr = data['status']; 

      String etaText = "-- menit";
      String distanceText = "-- km";
      
      if (data['route_geometry'] != null) {
        final routeGeometry = data['route_geometry'];
        final totalDistanceMeters = routeGeometry['total_distance_meters'];
        final totalDurationSeconds = routeGeometry['total_duration_seconds'];
        
        if (totalDistanceMeters != null) {
          distanceText = '${(totalDistanceMeters / 1000).toStringAsFixed(1)} km';
        }
        if (totalDurationSeconds != null) {
          etaText = '${(totalDurationSeconds / 60).ceil()} menit';
        }
      }

      if (data['ambulance'] != null && (etaText == "-- menit" || distanceText == "-- km")) {
        final ambulance = data['ambulance'];
        if (ambulance['eta'] != null && etaText == "-- menit") etaText = ambulance['eta'];
        if (ambulance['distance'] != null && distanceText == "-- km") distanceText = ambulance['distance'];
      }

      int mappedStatusInt = 0;
      if (_bookingStatusStr == "arrived") mappedStatusInt = 1; 
      if (_bookingStatusStr == "to_hospital") mappedStatusInt = 2; 
      if (_bookingStatusStr == "completed") mappedStatusInt = 3; 

      final newPickup = Position(pLng, pLat);
      final newDestination = Position(dLng, dLat);
      
      bool needRedrawRoutes = false;
      if (_pickupPosition != newPickup || _destinationPosition != newDestination) {
        needRedrawRoutes = true;
      }

      if (mounted) {
        setState(() {
          _pickupPosition = newPickup;
          _destinationPosition = newDestination;
          _currentTravelStatus = mappedStatusInt;
          _liveEtaText = etaText;
          _liveDistanceText = distanceText;
        });
      }

      if (needRedrawRoutes && _pickupPosition != null && _destinationPosition != null) {
        _drawStaticLocationMarkers(_pointAnnotationManager);
        _updateRouteLines(isFullScreenMap: false);
        
        if (_fullMapboxMap != null) {
          _drawStaticLocationMarkers(_fullPointAnnotationManager);
          _updateRouteLines(isFullScreenMap: true);
        }
      }
    } catch (e) {
      debugPrint("Gagal sinkronisasi API: $e");
    }
  }

  void _drawStaticLocationMarkers(PointAnnotationManager? manager) async {
    if (manager == null || _pickupPosition == null || _destinationPosition == null) return;
    
    await manager.deleteAll();
    if (manager == _pointAnnotationManager) _ambulanceAnnotation = null; 
    if (manager == _fullPointAnnotationManager) _fullAmbulanceAnnotation = null;
    
    await manager.create(PointAnnotationOptions(
      geometry: Point(coordinates: _pickupPosition!), iconImage: "patient-icon", iconSize: 0.35
    ));
    await manager.create(PointAnnotationOptions(
      geometry: Point(coordinates: _destinationPosition!), iconImage: "hospital-icon", iconSize: 0.35
    ));
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
        await targetMap.style.addStyleImage(
          target["id"] as String, 1.0, 
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
                gestureRecognizers: { Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()) },
                onMapCreated: (fullMap) async {
                  _fullMapboxMap = fullMap;
                  fullMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                  fullMap.compass.updateSettings(CompassSettings(enabled: false));
                  
                  _fullMapboxMap?.setCamera(
                    CameraOptions(
                      center: Point(coordinates: _currentDriverPosition!),
                      zoom: 15.5,
                    ),
                  );

                  await _generateAndRegisterCanvasIcons(fullMap);
                  _fullPolylineAnnotationManager = await fullMap.annotations.createPolylineAnnotationManager();
                  _fullPointAnnotationManager = await fullMap.annotations.createPointAnnotationManager();
                  
                  _drawStaticLocationMarkers(_fullPointAnnotationManager);
                  _updateRouteLines(isFullScreenMap: true);
                  _updateAmbulanceMarkerOnly(_currentDriverPosition!, isFullScreenMap: true);
                },
              ),
            ),
            
            // Tombol Close Modal
            Positioned(
              top: 20, 
              right: 20, 
              child: FloatingActionButton.small(
                heroTag: "closeFullMap",
                onPressed: () {
                  _fullMapboxMap = null;
                  _fullPointAnnotationManager = null;
                  _fullPolylineAnnotationManager = null;
                  _fullAmbulanceAnnotation = null;
                  _fullBluePolyline = null;
                  _fullGrayPolyline = null;
                  Navigator.pop(context);
                }, 
                backgroundColor: Colors.white, 
                child: const Icon(Icons.close_rounded, color: AppColors.textDark)
              )
            ),

            // Tombol Recenter Peta Modal (Selalu Tampil)
            Positioned(
              top: 80, 
              right: 20,
              child: FloatingActionButton.small(
                heroTag: "recenterFullMap",
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                onPressed: () {
                  if (_currentDriverPosition != null) {
                    _fullMapboxMap?.flyTo(
                      CameraOptions(center: Point(coordinates: _currentDriverPosition!), zoom: 15.5),
                      MapAnimationOptions(duration: 800),
                    );
                  }
                },
                child: const Icon(Icons.my_location_rounded),
              ),
            ),
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
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: MapWidget(
                          key: const ValueKey("trackingMap"),
                          styleUri: MapboxStyles.MAPBOX_STREETS,
                          onMapCreated: _onMapCreated,
                        ),
                      ),
                      
                      // Tombol Recenter untuk Peta Utama
                      Positioned(
                        top: 16,
                        right: 16,
                        child: FloatingActionButton.small(
                          heroTag: "recenterMainMap",
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          onPressed: () {
                            if (_currentDriverPosition != null) {
                              _mapboxMap?.flyTo(
                                CameraOptions(center: Point(coordinates: _currentDriverPosition!), zoom: 15.5),
                                MapAnimationOptions(duration: 800),
                              );
                            }
                          },
                          child: const Icon(Icons.my_location_rounded),
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
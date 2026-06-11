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
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager; 
  
  PointAnnotation? _ambulanceAnnotation;
  PolylineAnnotation? _bluePolyline; 
  PolylineAnnotation? _grayPolyline; 

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
    debugPrint('🔵 [MAP] Map created');
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
        center: Point(coordinates: _currentDriverPosition ??Position(106.816666, -6.200000)),
        zoom: 12.0,
        bearing: 0.0,
        pitch: 0.0,
      ),
    );
  }

void _subscribeToRealtimeLocation() {
  debugPrint('🔵 [REALTIME] Step 1/5: Starting realtime subscription...');
  debugPrint('🔵 [REALTIME] Booking ID: ${widget.bookingId}');
  
  final supabase = Supabase.instance.client;
  debugPrint('🔵 [REALTIME] Step 2/5: Supabase client: ${supabase != null ? "OK" : "NULL"}');
  
  final channelName = 'trip:${widget.bookingId}';
  debugPrint('🔵 [REALTIME] Channel name: $channelName');
  
  _realtimeChannel = supabase
      .channel(channelName)
      .onBroadcast(
        event: 'location_update',
        callback: (payload) {
          debugPrint('🔵 [REALTIME] Step 3/5: ========== BROADCAST RECEIVED ==========');
          debugPrint('🔵 [REALTIME] Raw payload type: ${payload.runtimeType}');
          debugPrint('🔵 [REALTIME] Raw payload: $payload');
          
          // 🔴 DEBUG: Cek semua keys yang ada di payload
          debugPrint('🔵 [REALTIME] Payload keys: ${payload.keys}');
          
          // 🔴 DEBUG: Coba akses dengan cara berbeda
          final testEvent = payload['event'];
          final testType = payload['type'];
          final testPayload = payload['payload'];
          
          debugPrint('🔵 [REALTIME] payload["event"]: $testEvent');
          debugPrint('🔵 [REALTIME] payload["type"]: $testType');
          debugPrint('🔵 [REALTIME] payload["payload"]: $testPayload');
          debugPrint('🔵 [REALTIME] payload["payload"] type: ${testPayload.runtimeType}');
          
          if (testPayload != null) {
            debugPrint('🔵 [REALTIME] Nested payload keys: ${testPayload.keys}');
            final nestedLat = testPayload['lat'];
            final nestedLng = testPayload['lng'];
            debugPrint('🔵 [REALTIME] Nested lat: $nestedLat');
            debugPrint('🔵 [REALTIME] Nested lng: $nestedLng');
          }
          
          try {
            // ✅ Ambil dari nested payload
            final broadcastPayload = payload['payload'];
            
            if (broadcastPayload == null) {
              debugPrint('🔴 [REALTIME ERROR] broadcastPayload is NULL!');
              return;
            }
            
            final lat = broadcastPayload['lat'];
            final lng = broadcastPayload['lng'];
            
            debugPrint('🔵 [REALTIME] Extracted lat: $lat (type: ${lat.runtimeType})');
            debugPrint('🔵 [REALTIME] Extracted lng: $lng (type: ${lng.runtimeType})');
            
            double? parsedLat;
            double? parsedLng;
            
            if (lat is double) {
              parsedLat = lat;
              debugPrint('🔵 [REALTIME] Lat already double: $parsedLat');
            } else if (lat is int) {
              parsedLat = lat.toDouble();
              debugPrint('🔵 [REALTIME] Lat converted from int: $parsedLat');
            } else if (lat is String) {
              parsedLat = double.tryParse(lat);
              debugPrint('🔵 [REALTIME] Lat parsed from string: $parsedLat');
            } else if (lat is num) {
              parsedLat = lat.toDouble();
              debugPrint('🔵 [REALTIME] Lat from num: $parsedLat');
            } else {
              debugPrint('🔴 [REALTIME] Unknown lat type: ${lat.runtimeType}');
            }
            
            if (lng is double) {
              parsedLng = lng;
              debugPrint('🔵 [REALTIME] Lng already double: $parsedLng');
            } else if (lng is int) {
              parsedLng = lng.toDouble();
              debugPrint('🔵 [REALTIME] Lng converted from int: $parsedLng');
            } else if (lng is String) {
              parsedLng = double.tryParse(lng);
              debugPrint('🔵 [REALTIME] Lng parsed from string: $parsedLng');
            } else if (lng is num) {
              parsedLng = lng.toDouble();
              debugPrint('🔵 [REALTIME] Lng from num: $parsedLng');
            } else {
              debugPrint('🔴 [REALTIME] Unknown lng type: ${lng.runtimeType}');
            }
            
            if (parsedLat != null && parsedLng != null && mounted) {
              debugPrint('📍📍📍 REALTIME LOCATION: $parsedLat, $parsedLng 📍📍📍');
              
              final newPosition = Position(parsedLng, parsedLat);
              
              debugPrint('🔵 [REALTIME] Step 4/5: New Position created: lng=${newPosition.lng}, lat=${newPosition.lat}');
              
              setState(() {
                _currentDriverPosition = newPosition;
                debugPrint('🔵 [REALTIME] State updated with new position');
              });
              
              debugPrint('🔵 [REALTIME] Step 5/5: Updating ambulance marker...');
              _updateAmbulanceMarkerOnly(newPosition);
              
              debugPrint('🔵 [REALTIME] Updating route lines...');
              _updateRouteLines();
              
              debugPrint('✅✅✅ REALTIME LOCATION UPDATE COMPLETE! ✅✅✅');
            } else {
              debugPrint('🔴 [REALTIME ERROR] Failed to parse lat/lng: lat=$parsedLat, lng=$parsedLng, mounted=$mounted');
            }
          } catch (e) {
            debugPrint('🔴 [REALTIME ERROR] Exception in broadcast callback: $e');
            debugPrint('🔴 [REALTIME ERROR] Stack trace: ${StackTrace.current}');
          }
        },
      )
      .subscribe((status, [error]) {
        debugPrint('🔵 [REALTIME SUBSCRIBE STATUS] Status: $status');
        if (error != null) {
          debugPrint('🔴 [REALTIME SUBSCRIBE ERROR] Error: $error');
        }
        if (status == RealtimeSubscribeStatus.subscribed) {
          debugPrint('✅✅✅ SUCCESSFULLY SUBSCRIBED TO CHANNEL: trip:${widget.bookingId} ✅✅✅');
        } else if (status == RealtimeSubscribeStatus.channelError) {
          debugPrint('❌❌❌ CHANNEL ERROR! Please check RLS policies ❌❌❌');
        } else if (status == RealtimeSubscribeStatus.timedOut) {
          debugPrint('⚠️⚠️⚠️ SUBSCRIPTION TIMEOUT ⚠️⚠️⚠️');
        }
      });
  
  debugPrint('🔵 [REALTIME] Subscription object created: ${_realtimeChannel != null}');
  debugPrint('🔌 Waiting for broadcast messages on channel: trip:${widget.bookingId}');
}

  void _testSendBroadcast() {
    debugPrint('🔵 [TEST] ========== MANUAL TEST BROADCAST ==========');
    debugPrint('🔵 [TEST] Manual test broadcast triggered');
    final supabase = Supabase.instance.client;
    
    final testLat = -6.2;
    final testLng = 106.8;
    
    debugPrint('🔵 [TEST] Sending test location: $testLat, $testLng');
    
    supabase.channel('trip:${widget.bookingId}').sendBroadcastMessage(
      event: 'location_update',
      payload: {
        'lat': testLat,
        'lng': testLng,
        'timestamp': DateTime.now().toIso8601String(),
        'test': true
      },
    ).then((_) {
      debugPrint('✅ [TEST] Broadcast sent successfully!');
    }).catchError((error) {
      debugPrint('❌ [TEST] Failed to send broadcast: $error');
    });
  }

  void _updateAmbulanceMarkerOnly(Position newPosition) async {
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
  }

  void _updateRouteLines() async {
    if (_polylineAnnotationManager == null || 
        _currentDriverPosition == null || 
        _pickupPosition == null || 
        _destinationPosition == null) return;

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
          lineColor: AppColors.primary.withValues(alpha: 0.3).toARGB32(),
          lineWidth: 6.0,
        ),
      );
    } else {
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
  }

  void _startLiveTrackingPolling() {
    debugPrint('🔵 [POLLING] Starting polling every 5 seconds');
    _fetchTrackingData(); 
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchTrackingData();
    });
  }

  Future<void> _fetchTrackingData() async {
    final String? jwtToken = AuthHelper.token;
    if (jwtToken == null) return;

    try {
      // ✅ Gunakan BookingService.getBookingDetails
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
          final distanceInKm = totalDistanceMeters / 1000;
          distanceText = '${distanceInKm.toStringAsFixed(1)} km';
        }
        
        if (totalDurationSeconds != null) {
          final minutes = (totalDurationSeconds / 60).ceil();
          etaText = '$minutes menit';
        }
      }

      // Fallback ke data ambulance jika route_geometry tidak ada
      if (data['ambulance'] != null && (etaText == "-- menit" || distanceText == "-- km")) {
        final ambulance = data['ambulance'];
        if (ambulance['eta'] != null && etaText == "-- menit") etaText = ambulance['eta'];
        if (ambulance['distance'] != null && distanceText == "-- km") distanceText = ambulance['distance'];
      }

      int mappedStatusInt = 0;
      if (_bookingStatusStr == "arrived") {
        mappedStatusInt = 1; 
      } else if (_bookingStatusStr == "to_hospital") {
        mappedStatusInt = 2; 
      } else if (_bookingStatusStr == "completed") {
        mappedStatusInt = 3; 
      }

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
        _updateRouteLines();
      }
    } catch (e) {
      debugPrint("Gagal sinkronisasi API: $e");
    }
  }

  void _drawStaticLocationMarkers(PointAnnotationManager? manager) async {
    if (manager == null || _pickupPosition == null || _destinationPosition == null) return;
    
    await manager.deleteAll();
    _ambulanceAnnotation = null; 
    
    await manager.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: _pickupPosition!), 
        iconImage: "patient-icon", 
        iconSize: 0.35
      )
    );
    await manager.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: _destinationPosition!), 
        iconImage: "hospital-icon", 
        iconSize: 0.35
      )
    );
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
                    await polylineManager.create(PolylineAnnotationOptions(geometry: LineString(coordinates: [_pickupPosition!, _destinationPosition!]), lineColor: AppColors.primary.withValues(alpha: 0.3).toARGB32(), lineWidth: 7.0));
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
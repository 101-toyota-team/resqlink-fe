import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/order/ambulance_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../screens/order/order_processing_screen.dart';
import '../../services/nearby_provider_service.dart';
import '../../services/auth_helper.dart';
import '../../widgets/order/ambulance_detail_bottom_sheet.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../schema/location.dart';
import '../../schema/provider.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../utils/error_handler.dart';
import '../../widgets/common/rq_error_state.dart';

class AmbulanceSelectionScreen extends StatefulWidget {
  final LocationData pickupLocation;
  final LocationData destinationLocation;
  final String patientCondition;

  const AmbulanceSelectionScreen({
    super.key,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.patientCondition,
  });

  @override
  State<AmbulanceSelectionScreen> createState() => _AmbulanceSelectionScreenState();
}

class _AmbulanceSelectionScreenState extends State<AmbulanceSelectionScreen> {
  final NearbyProviderService _nearbyService = NearbyProviderService();
  List<Provider> _providers = [];
  Provider? _selectedProvider;
  bool _isLoading = true;
  String? _errorMessage;
  String? _dummyDuration;
  String? _dummyPrice;

  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  
  // Marker references
  PointAnnotation? _pickupMarker;
  PointAnnotation? _destinationMarker;
  PointAnnotation? _selectedAmbulanceMarker;
  
  bool _isMapReady = false;
  bool _hasInitialZoom = false;

  @override
  void initState() {
    super.initState();
    _fetchNearbyProviders();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _isMapReady = true;
    
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));

    // Initialize annotation manager
    _pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    
    // Register custom icons
    await _registerCustomIcons();
    
    // Draw all markers
    await _drawAllMarkers();
    
    // Fit camera to show pickup and destination
    _fitCameraToBothMarkers();
  }

  Future<void> _registerCustomIcons() async {
    if (_mapboxMap == null) return;
    
    // Icon untuk pickup (patient-icon)
    await _createCustomIcon(
      id: "patient-icon",
      iconData: Icons.person_pin_circle_rounded,
      color: Colors.green,
      label: "LOKASI JEMPUT",
    );
    
    // Icon untuk destination (hospital-icon)
    await _createCustomIcon(
      id: "hospital-icon",
      iconData: Icons.local_hospital_rounded,
      color: Colors.orange,
      label: "RUMAH SAKIT TUJUAN",
    );
    
    // Icon untuk ambulance yang dipilih
    await _createCustomIcon(
      id: "ambulance-icon",
      iconData: Icons.airport_shuttle_rounded,
      color: AppColors.primary,
      label: "ARMADA TERPILIH",
    );
  }

  Future<void> _createCustomIcon({
    required String id,
    required IconData iconData,
    required Color color,
    required String label,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 200, 80));
    
    // Gambar background marker
    final paint = Paint()..color = Colors.white;
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.2);
    
    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(2, 4, 196, 44), const Radius.circular(12)),
      shadowPaint,
    );
    
    // Background putih
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 196, 44), const Radius.circular(12)),
      paint,
    );
    
    // Border tipis
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 196, 44), const Radius.circular(12)),
      Paint()..color = color.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    
    // Icon
    final iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 28,
        fontFamily: iconData.fontFamily,
        color: color,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(canvas, const Offset(12, 8));
    
    // Label text
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(48, 12));
    
    // Subtitle (kosong)
    final subtitlePainter = TextPainter(textDirection: TextDirection.ltr);
    subtitlePainter.text = const TextSpan(
      style: TextStyle(
        fontSize: 9,
        color: Color(0xFF999999),
      ),
    );
    subtitlePainter.layout();
    subtitlePainter.paint(canvas, Offset(48, 26));
    
    // Segitiga bawah (pointer)
    final path = Path();
    path.moveTo(90, 44);
    path.lineTo(98, 56);
    path.lineTo(106, 44);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(path, Paint()..color = color.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    
    final img = await recorder.endRecording().toImage(200, 80);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData != null) {
      await _mapboxMap?.style.addStyleImage(
        id,
        1.0,
        MbxImage(width: 200, height: 80, data: byteData.buffer.asUint8List()),
        false,
        [],
        [],
        null,
      );
    }
  }

  // Draw all markers on map
  Future<void> _drawAllMarkers() async {
    if (_pointAnnotationManager == null) return;
    
    // Clear existing markers
    await _pointAnnotationManager?.deleteAll();
    _pickupMarker = null;
    _destinationMarker = null;
    _selectedAmbulanceMarker = null;
    
    // Draw pickup marker
    await _drawPickupMarker();
    
    // Draw destination marker
    await _drawDestinationMarker();
    
    // Draw selected ambulance marker if exists
    if (_selectedProvider != null && 
        _selectedProvider!.latitude != null && 
        _selectedProvider!.longitude != null) {
      await _drawSelectedAmbulanceMarker();
    }
  }

  Future<void> _drawPickupMarker() async {
    if (_pointAnnotationManager == null) return;
    if (widget.pickupLocation.latitude == 0 || widget.pickupLocation.longitude == 0) return;
    
    _pickupMarker = await _pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(
          widget.pickupLocation.longitude, 
          widget.pickupLocation.latitude
        )),
        iconImage: "patient-icon",
        iconSize: 0.8,
      ),
    );
  }

  Future<void> _drawDestinationMarker() async {
    if (_pointAnnotationManager == null) return;
    if (widget.destinationLocation.latitude == 0 || widget.destinationLocation.longitude == 0) return;
    
    _destinationMarker = await _pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(
          widget.destinationLocation.longitude, 
          widget.destinationLocation.latitude
        )),
        iconImage: "hospital-icon",
        iconSize: 0.8,
      ),
    );
  }

  // Future<void> _drawSelectedAmbulanceMarker() async {
  //   if (_pointAnnotationManager == null) return;
  //   if (_selectedProvider!.latitude == null || _selectedProvider!.longitude == null) return;
    
  //   if (_selectedAmbulanceMarker == null) {
  //     _selectedAmbulanceMarker = await _pointAnnotationManager?.create(
  //       PointAnnotationOptions(
  //         geometry: Point(coordinates: Position(
  //           _selectedProvider!.longitude!, 
  //           _selectedProvider!.latitude!
  //         )),
  //         iconImage: "ambulance-icon",
  //         iconSize: 0.8,
  //       ),
  //     );
  //   } else {
  //     _selectedAmbulanceMarker?.geometry = Point(coordinates: Position(
  //       _selectedProvider!.longitude!, 
  //       _selectedProvider!.latitude!
  //     ));
  //     await _pointAnnotationManager?.update(_selectedAmbulanceMarker!);
  //   }
  // }

  Future<void> _drawSelectedAmbulanceMarker() async {
    if (_pointAnnotationManager == null) return;
    
    // Cek apakah koordinat ambulance sama dengan destination
    final bool isSameAsDestination = 
        (_selectedProvider!.latitude! - widget.destinationLocation.latitude).abs() < 0.0001 &&
        (_selectedProvider!.longitude! - widget.destinationLocation.longitude).abs() < 0.0001;
    
    debugPrint('is same as destination: $isSameAsDestination');

    final iconAnchor = isSameAsDestination ? IconAnchor.BOTTOM : IconAnchor.CENTER;
    
    if (_selectedAmbulanceMarker == null) {
      _selectedAmbulanceMarker = await _pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(
            _selectedProvider!.longitude!, 
            _selectedProvider!.latitude!
          )),
          iconImage: "ambulance-icon",
          iconSize: 0.8,
          iconAnchor: iconAnchor,
        ),
      );
    } else {
      _selectedAmbulanceMarker?.geometry = Point(coordinates: Position(
        _selectedProvider!.longitude!, 
        _selectedProvider!.latitude!
      ));
      await _pointAnnotationManager?.update(_selectedAmbulanceMarker!);
    }
  }

  // Method untuk mengatur kamera agar menampilkan kedua marker utama (pickup & destination)
  Future<void> _fitCameraToBothMarkers() async {
    if (_mapboxMap == null) return;
    
    // Kumpulkan koordinat yang valid (pickup dan destination)
    List<Position> coordinates = [];
    
    if (widget.pickupLocation.latitude != 0 && widget.pickupLocation.longitude != 0) {
      coordinates.add(Position(widget.pickupLocation.longitude, widget.pickupLocation.latitude));
    }
    
    if (widget.destinationLocation.latitude != 0 && widget.destinationLocation.longitude != 0) {
      coordinates.add(Position(widget.destinationLocation.longitude, widget.destinationLocation.latitude));
    }
    
    if (coordinates.isEmpty) return;
    
    // Jika hanya satu titik, langsung fly ke titik tersebut
    if (coordinates.length == 1) {
      await _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: coordinates.first),
          zoom: 15.0,
        ),
        MapAnimationOptions(duration: 800),
      );
      return;
    }
    
    // Hitung bounds untuk kedua titik
    num minLng = coordinates[0].lng;
    num maxLng = coordinates[0].lng;
    num minLat = coordinates[0].lat;
    num maxLat = coordinates[0].lat;
    
    for (var coord in coordinates) {
      if (coord.lng < minLng) minLng = coord.lng;
      if (coord.lng > maxLng) maxLng = coord.lng;
      if (coord.lat < minLat) minLat = coord.lat;
      if (coord.lat > maxLat) maxLat = coord.lat;
    }
    
    final latRange = maxLat - minLat;
    final centerLat = (minLat + maxLat) / 2 + (latRange * 0.5);
    final centerLng = (minLng + maxLng) / 2;
    
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double zoom = 12.0;
    if (maxDiff < 0.01) {
      zoom = 14.0;
    } else if (maxDiff < 0.05) {
      zoom = 12.0;
    } else if (maxDiff < 0.1) {
      zoom = 11.0;
    } else if (maxDiff < 0.5) {
      zoom = 10.0;
    } else {
      zoom = 9.0;
    }

    zoom = zoom.clamp(9.0, 16.0);
    
    try {
      await _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(centerLng, centerLat)),
          zoom: zoom,
        ),
        MapAnimationOptions(duration: 800),
      );
      debugPrint('✅ Camera fit to both markers at zoom: $zoom');
    } catch (e) {
      debugPrint('Error fitting camera: $e');
      await _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: coordinates.first),
          zoom: 13.0,
        ),
        MapAnimationOptions(duration: 800),
      );
    }
  }

  // Method untuk zoom ke semua marker (pickup, destination, dan ambulance terpilih)
  Future<void> _fitCameraToAllMarkers() async {
    if (_mapboxMap == null) return;
    
    List<Position> coordinates = [];
    
    // Pickup
    if (widget.pickupLocation.latitude != 0 && widget.pickupLocation.longitude != 0) {
      coordinates.add(Position(widget.pickupLocation.longitude, widget.pickupLocation.latitude));
    }
    
    // Destination
    if (widget.destinationLocation.latitude != 0 && widget.destinationLocation.longitude != 0) {
      coordinates.add(Position(widget.destinationLocation.longitude, widget.destinationLocation.latitude));
    }
    
    // Selected ambulance
    if (_selectedProvider != null && 
        _selectedProvider!.latitude != null && 
        _selectedProvider!.longitude != null) {
      coordinates.add(Position(_selectedProvider!.longitude!, _selectedProvider!.latitude!));
    }
    
    if (coordinates.isEmpty) return;
    
    if (coordinates.length == 1) {
      await _mapboxMap?.flyTo(
        CameraOptions(center: Point(coordinates: coordinates.first), zoom: 15.0),
        MapAnimationOptions(duration: 800),
      );
      return;
    }
    
    num minLng = coordinates[0].lng;
    num maxLng = coordinates[0].lng;
    num minLat = coordinates[0].lat;
    num maxLat = coordinates[0].lat;
    
    for (var coord in coordinates) {
      if (coord.lng < minLng) minLng = coord.lng;
      if (coord.lng > maxLng) maxLng = coord.lng;
      if (coord.lat < minLat) minLat = coord.lat;
      if (coord.lat > maxLat) maxLat = coord.lat;
    }
    
    final latRange = maxLat - minLat;
    final centerLat = (minLat + maxLat) / 2 + (latRange * 0.5);
    final centerLng = (minLng + maxLng) / 2;
    
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double zoom = 12.0;
    if (maxDiff < 0.01) {
      zoom = 14.0;
    } else if (maxDiff < 0.05) {
      zoom = 12.0;
    } else if (maxDiff < 0.1) {
      zoom = 11.0;
    } else if (maxDiff < 0.5) {
      zoom = 10.0;
    } else {
      zoom = 9.0;
    }

    debugPrint('Fitting camera to all markers with zoom: $zoom');
    
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(centerLng, centerLat)),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 800),
    );
  }

  Future<void> _fetchNearbyProviders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = AuthHelper.token;
      
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }
      
      final result = await _nearbyService.getNearbyProviders(
        token, 
        h3Index: widget.pickupLocation.h3Index,
        latitude: widget.pickupLocation.latitude,
        longitude: widget.pickupLocation.longitude,
      );
      
      List<dynamic> providersData = [];
      
      if (result is List) {
        providersData = result;
      } else if (result is Map<String, dynamic>) {
        if (result.containsKey('data')) {
          providersData = result['data'] is List ? result['data'] : [];
        } else if (result.containsKey('providers')) {
          providersData = result['providers'] is List ? result['providers'] : [];
        }
      }

      final List<Provider> fetchedProviders = [];
      
      for (var providerJson in providersData) {
        try {
          final provider = Provider.fromJson(providerJson);
          fetchedProviders.add(provider);
        } catch (e) {
          // Skip invalid data
        }
      }

      setState(() {
        _providers = fetchedProviders;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _providers = [];
      });
    }
  }

  void _selectProvider(Provider provider, String dummyDuration, String dummyPrice) {
    setState(() {
      _selectedProvider = provider;
      _dummyDuration = dummyDuration;
      _dummyPrice = dummyPrice;
    });
    
    // Draw ambulance marker and zoom to show all markers
    _drawSelectedAmbulanceMarker();
    _fitCameraToAllMarkers();
  }

  void _showAmbulanceDetail(Provider provider, String dummyDuration, String dummyPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => AmbulanceDetailBottomSheet(
          name: provider.name,
          distance: provider.distance,
          duration: dummyDuration,
          price: dummyPrice,
          treatment: 'Dengan Perawatan lengkap + Oksigen',
          phoneNumber: provider.phone,
          providerType: provider.providerType,
          address: provider.address,
          onSelect: () {
            _selectProvider(provider, dummyDuration, dummyPrice);
          },
        ),
      ),
    );
  }

  void _confirmAndProceed() {
    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih provider ambulans terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderProcessingScreen(
          selectedProvider: _selectedProvider!,
          pickupLocation: widget.pickupLocation,
          destinationLocation: widget.destinationLocation,
          patientCondition: widget.patientCondition,
          dummyPrice: _dummyPrice,
        ),
      ),
    );
  }

  String _getDummyDuration(String providerId) {
    final hash = providerId.hashCode.abs();
    final minVal = 1 + (hash % 5); // 1-5
    final maxVal = minVal + 2;
    return '$minVal-$maxVal menit';
  }

  String _getDummyPrice(String providerId) {
    final hash = providerId.hashCode.abs();
    final price = 300000 + (hash % 200001); // 300k - 500k
    return 'Rp${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          // Map Widget
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6, 
            child: MapWidget(
              key: const ValueKey("selectionMapboxWidget"),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: _onMapCreated,
            ),
          ),

          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
              ),
            ),
          ),

          // Location Selector (Read-only)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: 0.95,
              child: LocationSelector(
                initialPickup: widget.pickupLocation.address,
                initialDestination: widget.destinationLocation.address,
                isReadOnly: true,
              ), 
            ),
          ),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3DE),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/medic_pattern3.png'),
                    fit: BoxFit.cover,
                    opacity: 0.2,
                  ),
                ),
                child: Column(
                  children: [
                    // Handle Bar
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pilih Armada Ambulan",
                          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),

                    // Selected Provider Summary (if any)
                    if (_selectedProvider != null)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ARMADA DIPILIH',
                                    style: AppTypography.captionSmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedProvider!.name,
                                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _selectedProvider = null),
                              icon: const Icon(Icons.close, size: 20, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),

                    // States
                    if (_isLoading)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColors.primary),
                              const SizedBox(height: 16),
                              Text('Mencari armada terdekat...'),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isLoading && _errorMessage != null)
                      Expanded(
                        child: RqErrorState(
                          fullScreen: false,
                          message: ErrorHandler.getErrorMessage(_errorMessage),
                          onRetry: _fetchNearbyProviders,
                        ),
                      ),
                    
                    if (!_isLoading && _errorMessage == null && _providers.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_hospital_outlined, size: 56, color: AppColors.textGrey),
                              SizedBox(height: 16),
                              Text('Tidak ada armada tersedia di sekitar Anda', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isLoading && _errorMessage == null && _providers.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _providers.length,
                          itemBuilder: (context, index) {
                            final provider = _providers[index];
                            final isSelected = _selectedProvider?.id == provider.id;

                            final dummyDuration = _getDummyDuration(provider.id);
                            final dummyPrice = _getDummyPrice(provider.id);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AmbulanceCard(
                                name: provider.name,
                                distance: provider.distance,
                                duration: dummyDuration,
                                price: dummyPrice,
                                treatment: 'Dengan Perawatan',
                                isNearest: index == 0,
                                isSelected: isSelected,
                                onTap: () => _showAmbulanceDetail(provider, dummyDuration, dummyPrice),
                                onSelect: () => _selectProvider(provider, dummyDuration, dummyPrice),
                                onDetail: () => _showAmbulanceDetail(provider, dummyDuration, dummyPrice),
                              ),
                            );
                          },
                        ),
                      ),

                    // Hanya tampilkan tombol konfirmasi jika tidak ada error dan tidak sedang loading
                    if (!_isLoading && _errorMessage == null && _providers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: GradientButton(
                            title: _selectedProvider != null 
                                ? "Konfirmasi Pesanan" 
                                : "Pilih Armada Terlebih Dahulu",
                            onPressed: _confirmAndProceed,
                          ),
                        ),
                      ),
                    
                    // Beri sedikit ruang di bawah jika dalam state error/empty agar tidak mentok
                    if (_errorMessage != null || _providers.isEmpty)
                      const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
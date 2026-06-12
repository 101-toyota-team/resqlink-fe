import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../schema/location.dart';
import '../../schema/provider.dart';
import '../../services/booking_service.dart';
import '../../services/auth_helper.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../screens/home/home_screen.dart';
import 'order_success_screen.dart';
import '../../utils/error_handler.dart';
import '../../widgets/common/rq_error_state.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class OrderProcessingScreen extends StatefulWidget {
  final Provider selectedProvider;
  final LocationData? pickupLocation;
  final LocationData? destinationLocation;
  final String? dummyPrice;
  final String patientCondition;
  final bool autoStart;
  final bool showMap;

  const OrderProcessingScreen({
    super.key,
    required this.selectedProvider,
    this.pickupLocation,
    this.destinationLocation,
    this.dummyPrice,
    required this.patientCondition,
    this.autoStart = false,
    this.showMap = true,
  });

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

enum BookingErrorType { timeout, rejected, system }

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  bool _isBooking = false;
  bool _isBookingSuccess = false;
  bool _isPolling = false;
  String? _bookingError;
  BookingErrorType? _errorType;
  Map<String, dynamic>? _bookingResult;
  String? _currentStatus;
  int _pollingAttempts = 0;
  static const int _maxPollingAttempts = 60;
  Timer? _pollingTimer;

  // Map related
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  
  // Marker references
  PointAnnotation? _pickupMarker;
  PointAnnotation? _destinationMarker;
  PointAnnotation? _selectedAmbulanceMarker;
  
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confirmBooking();
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
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
    
    // Fit camera to show all markers
    _fitCameraToAllMarkers();
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
    
    // Draw selected ambulance marker
    await _drawSelectedAmbulanceMarker();
  }

  Future<void> _drawPickupMarker() async {
    if (_pointAnnotationManager == null) return;
    if (widget.pickupLocation == null) return;
    if (widget.pickupLocation!.latitude == 0 || widget.pickupLocation!.longitude == 0) return;
    
    _pickupMarker = await _pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(
          widget.pickupLocation!.longitude, 
          widget.pickupLocation!.latitude
        )),
        iconImage: "patient-icon",
        iconSize: 0.8,
      ),
    );
  }

  Future<void> _drawDestinationMarker() async {
    if (_pointAnnotationManager == null) return;
    if (widget.destinationLocation == null) return;
    if (widget.destinationLocation!.latitude == 0 || widget.destinationLocation!.longitude == 0) return;
    
    _destinationMarker = await _pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(
          widget.destinationLocation!.longitude, 
          widget.destinationLocation!.latitude
        )),
        iconImage: "hospital-icon",
        iconSize: 0.8,
      ),
    );
  }

  Future<void> _drawSelectedAmbulanceMarker() async {
    if (_pointAnnotationManager == null) return;
    if (widget.selectedProvider.latitude == null || widget.selectedProvider.longitude == null) return;
    
    // Cek apakah koordinat ambulance sama dengan destination
    final bool isSameAsDestination = widget.destinationLocation != null &&
        (widget.selectedProvider.latitude! - widget.destinationLocation!.latitude).abs() < 0.0001 &&
        (widget.selectedProvider.longitude! - widget.destinationLocation!.longitude).abs() < 0.0001;
    
    final iconAnchor = isSameAsDestination ? IconAnchor.BOTTOM : IconAnchor.CENTER;
    
    if (_selectedAmbulanceMarker == null) {
      _selectedAmbulanceMarker = await _pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(
            widget.selectedProvider.longitude!, 
            widget.selectedProvider.latitude!
          )),
          iconImage: "ambulance-icon",
          iconSize: 0.8,
          iconAnchor: iconAnchor,
        ),
      );
    } else {
      _selectedAmbulanceMarker?.geometry = Point(coordinates: Position(
        widget.selectedProvider.longitude!, 
        widget.selectedProvider.latitude!
      ));
      await _pointAnnotationManager?.update(_selectedAmbulanceMarker!);
    }
  }

  // Method untuk zoom ke semua marker (pickup, destination, dan ambulance)
  Future<void> _fitCameraToAllMarkers() async {
    if (_mapboxMap == null) return;
    
    List<Position> coordinates = [];
    
    // Pickup
    if (widget.pickupLocation != null && 
        widget.pickupLocation!.latitude != 0 && 
        widget.pickupLocation!.longitude != 0) {
      coordinates.add(Position(widget.pickupLocation!.longitude, widget.pickupLocation!.latitude));
    }
    
    // Destination
    if (widget.destinationLocation != null && 
        widget.destinationLocation!.latitude != 0 && 
        widget.destinationLocation!.longitude != 0) {
      coordinates.add(Position(widget.destinationLocation!.longitude, widget.destinationLocation!.latitude));
    }
    
    // Selected ambulance
    if (widget.selectedProvider.latitude != null && widget.selectedProvider.longitude != null) {
      coordinates.add(Position(widget.selectedProvider.longitude!, widget.selectedProvider.latitude!));
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
    
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(centerLng, centerLat)),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.selectedProvider;
    final pickup = widget.pickupLocation;
    final destination = widget.destinationLocation;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: widget.showMap 
              ? MapWidget(
                  key: const ValueKey("processingMapboxWidget"),
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  onMapCreated: _onMapCreated,
                )
              : Container(
                  color: AppColors.white,
                  child: Opacity(
                    opacity: 0.05,
                    child: Image.asset(
                      'assets/images/medic_pattern.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (!_isBooking && !_isPolling) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: (_isBooking || _isPolling) ? Colors.grey : AppColors.textDark,
                  size: 20,
                ),
              ),
            ),
          ),

          // Location Selector (Read-only) - Sama seperti ambulance selection
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: 0.95,
              child: LocationSelector(
                initialPickup: pickup?.address ?? "Lokasi Jemput",
                initialDestination: destination?.address ?? "Lokasi Tujuan",
                isReadOnly: true,
              ),
            ),
          ),

          // ✅ Bottom Sheet - Sama seperti ambulance_selection_screen
          DraggableScrollableSheet(
            initialChildSize: _isBookingSuccess ? 0.65 : 0.5,
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
                    
                    // Status Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildStatusSection(),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            if (_isBookingSuccess && _bookingResult != null)
                              _buildSuccessState()
                            else if (_bookingError != null && !_isBooking && !_isPolling)
                              _buildErrorState()
                            else ...[
                              const Divider(color: Color(0xFFCC9E60), thickness: 1),
                              const SizedBox(height: 15),

                              // Patient Condition Info
                              _buildPatientConditionInfo(),
                              
                              const SizedBox(height: 15),
                              const Divider(color: Color(0xFFCC9E60), thickness: 0.5),
                              const SizedBox(height: 15),

                              // Provider Info Section
                              _buildProviderInfo(provider),
                              
                              const SizedBox(height: 20),
                              const Divider(color: Color(0xFFCC9E60), thickness: 0.5),
                              const SizedBox(height: 15),

                              // Price Info
                              _buildPriceInfo(),
                              
                              const SizedBox(height: 24),
                              
                              // Action Buttons (Confirm & Cancel)
                              if (!_isBooking && !_isPolling)
                                _buildActionButtons(),
                              
                              // Loading saat booking
                              if (_isBooking)
                                _buildLoadingState(isPolling: false),
                              
                              // Polling state (menunggu konfirmasi provider)
                              if (_isPolling)
                                _buildLoadingState(isPolling: true),
                            ],
                            
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    String title;
    String subtitle;
    IconData? icon;
    Color? iconColor;
    Color? titleColor;

    if (_isBooking) {
      title = "Membuat Pesanan...";
      subtitle = "Mohon tunggu sebentar";
      icon = Icons.hourglass_empty;
      iconColor = const Color(0xFFD4A843);
      titleColor = Colors.black87;
    } else if (_isPolling) {
      title = "Menunggu Konfirmasi Provider";
      subtitle = "Provider sedang memproses pesanan Anda";
      icon = Icons.access_time;
      iconColor = const Color(0xFFD4A843);
      titleColor = Colors.black87;
    } else if (_isBookingSuccess) {
      title = "Pesanan Dikonfirmasi!";
      subtitle = "Provider telah menerima pesanan Anda";
      icon = Icons.check_circle;
      iconColor = Colors.green;
      titleColor = Colors.green;
    } else if (_bookingError != null) {
      title = "Pemesanan Gagal";
      subtitle = "Silakan coba lagi";
      icon = Icons.error_outline;
      iconColor = Colors.red;
      titleColor = Colors.red;
    } else {
      title = "Konfirmasi Pemesanan";
      subtitle = "Silakan periksa kembali detail pemesanan Anda";
      icon = Icons.info;
      iconColor = const Color(0xFFD4A843);
      titleColor = Colors.black87;
    }

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.body.copyWith(color: AppColors.textGrey, fontSize: 13),
              ),
              if (_isPolling && _currentStatus != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A843).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Status: $_currentStatus',
                    style: const TextStyle(fontSize: 11, color: Color(0xFFD4A843)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _confirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4503A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Konfirmasi Pesanan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _cancelOrder,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              "Batalkan Pesanan",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState({required bool isPolling}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD4A843), width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4503A)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPolling 
                          ? "Menunggu konfirmasi dari provider..." 
                          : "Sedang memproses...",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPolling
                          ? "Ini mungkin memerlukan waktu beberapa saat"
                          : "Jangan tutup aplikasi",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey.shade100,
            ),
            child: Text(
              "Batalkan Pesanan",
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, size: 48, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text(
                "Pesanan Berhasil!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Provider telah menerima pesanan Anda. Armada akan segera dikirim ke lokasi Anda.",
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Booking ID: ${_bookingResult!['id']}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur tracking akan segera tersedia'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4503A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Pantau Lokasi Armada",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD4503A), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              "Kembali ke Beranda",
              style: TextStyle(
                color: Color(0xFFD4503A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    String title;
    String message;
    IconData icon;
    Color color;

    switch (_errorType) {
      case BookingErrorType.timeout:
        title = "Provider Tidak Merespon";
        message = "Maaf, provider yang Anda pilih tidak memberikan konfirmasi dalam waktu yang ditentukan. Silakan coba provider lain atau ulangi pesanan.";
        icon = Icons.timer_off_rounded;
        color = Colors.orange.shade700;
        break;
      case BookingErrorType.rejected:
        title = "Pesanan Ditolak";
        message = "Maaf, provider saat ini tidak dapat menerima pesanan Anda. Hal ini bisa terjadi karena armada sedang penuh atau kendala teknis lainnya.";
        icon = Icons.block_flipped;
        color = Colors.red.shade700;
        break;
      case BookingErrorType.system:
      default:
        title = "Terjadi Kesalahan";
        message = ErrorHandler.getErrorMessage(_bookingError);
        icon = Icons.error_outline_rounded;
        color = Colors.red.shade700;
        break;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTypography.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _errorType == BookingErrorType.timeout 
                ? () => Navigator.pop(context)
                : _confirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4503A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              _errorType == BookingErrorType.timeout ? "Cari Provider Lain" : "Coba Lagi",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _cancelOrder,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD4503A), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              "Batalkan Pesanan",
              style: TextStyle(
                color: Color(0xFFD4503A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isBooking = true;
      _bookingError = null;
    });

    try {
      final token = AuthHelper.token;
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final pickup = widget.pickupLocation;
      final destination = widget.destinationLocation;
      
      if (pickup == null || destination == null) {
        throw Exception('Lokasi pickup atau destination tidak lengkap.');
      }

      final result = await BookingService.createBooking(
        token: token,
        providerId: "28fbd41f-f2b4-4ed7-b3b3-cace745d2c4c",
        bookingType: 'medis',
        patientCondition: widget.patientCondition,
        pickupAddress: pickup.address,
        pickupLat: pickup.latitude,
        pickupLng: pickup.longitude,
        pickupH3: pickup.h3Index,
        destinationAddress: destination.address,
        destinationLat: destination.latitude,
        destinationLng: destination.longitude,
      );

      final bookingId = result['id'];

      setState(() {
        _isBooking = false;
        _isPolling = true;
        _bookingResult = result;
      });

      _startPolling(bookingId, token);

    } catch (e) {
      if (mounted) {
        setState(() {
          _isBooking = false;
          _bookingError = e.toString();
          _errorType = BookingErrorType.system;
        });
      }
    }
  }

  void _startPolling(String bookingId, String token) {
    _pollingAttempts = 0;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _pollingAttempts++;
      
      if (_pollingAttempts > _maxPollingAttempts) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isPolling = false;
            _errorType = BookingErrorType.timeout;
            _bookingError = 'Waktu tunggu habis. Provider tidak memberikan respon dalam waktu yang ditentukan.';
          });
        }
        return;
      }

      try {
        final statusResult = await BookingService.getBookingStatus(bookingId, token);
        final status = statusResult['status'] as String?;
                
        if (mounted) {
          setState(() {
            _currentStatus = status;
          });
        }
        
        if (status == 'confirmed') {
          timer.cancel();
          if (mounted) {
            setState(() {
              _isPolling = false;
              _isBookingSuccess = true;
              _bookingResult = statusResult;
            });

            final now = DateTime.now();
            final formattedDate = "${now.day} ${_getMonthName(now.month)} ${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OrderSuccessScreen(
                  providerName: widget.selectedProvider.name,
                  serviceType: "Ambulans Medis",
                  bookingDate: formattedDate,
                ),
              ),
            );
          }
        } else if (status == 'cancelled' || status == 'rejected') {
          timer.cancel();
          if (mounted) {
            setState(() {
              _isPolling = false;
              _errorType = BookingErrorType.rejected;
              _bookingError = 'Pesanan Anda ditolak atau dibatalkan oleh provider.';
            });
          }
        }
      } catch (e) {
        // Continue polling
      }
    });
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan'),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              if (_isPolling && _bookingResult != null) {
                try {
                  final token = AuthHelper.token;
                  if (token != null) {
                    await BookingService.cancelBooking(_bookingResult!['id'], token);
                  }
                } catch (e) {
                  // Ignore
                }
              }
              
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }
  
  Widget _buildPatientConditionInfo() {
    final isWelcab = widget.patientCondition.startsWith('Welcab:');
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCC9E60), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3DE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                isWelcab ? Icons.info_outline : Icons.medical_information, 
                size: 22, 
                color: const Color(0xFFD4503A)
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWelcab ? 'Detail Pesanan' : 'Kondisi Pasien',
                  style: AppTypography.caption.copyWith(color: AppColors.textGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.patientCondition.isEmpty 
                      ? 'Tidak disebutkan' 
                      : widget.patientCondition,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderInfo(Provider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCC9E60), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3DE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.local_hospital, size: 28, color: Color(0xFFD4503A)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: AppTypography.title.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        provider.address,
                        style: AppTypography.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      provider.phone,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.payments_outlined, color: AppColors.primary),
            const SizedBox(width: 10),
            Text("Total Pembayaran", style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        Text(
          widget.dummyPrice ?? "Rp300.000",
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
      ],
    );
  }
}
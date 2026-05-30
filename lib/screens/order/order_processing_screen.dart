import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../schema/location.dart';
import '../../schema/provider.dart';
import '../../services/booking_service.dart';
import '../../services/auth_helper.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../screens/home/home_screen.dart';

class OrderProcessingScreen extends StatefulWidget {
  final Provider selectedProvider;
  final LocationData? pickupLocation;
  final LocationData? destinationLocation;
  final String patientCondition;

  const OrderProcessingScreen({
    super.key,
    required this.selectedProvider,
    this.pickupLocation,
    this.destinationLocation,
    required this.patientCondition,
  });

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  bool _isBooking = false;
  bool _isBookingSuccess = false;
  String? _bookingError;
  Map<String, dynamic>? _bookingResult;

  @override
  Widget build(BuildContext context) {
    final provider = widget.selectedProvider;
    final pickup = widget.pickupLocation;
    final destination = widget.destinationLocation;

    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: MapWidget(
              key: const ValueKey("processingMapboxWidget"),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(
                  pickup?.longitude ?? provider.longitude,
                  pickup?.latitude ?? provider.latitude,
                )),
                zoom: 14.0,
              ),
              onMapCreated: (mapboxMap) {
                mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
              },
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (!_isBooking) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: _isBooking ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),

          // Location Selector (Read-only)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: 0.9,
              child: LocationSelector(
                initialPickup: pickup?.address ?? "Lokasi Jemput",
                initialDestination: destination?.address ?? "Lokasi Tujuan",
                isReadOnly: true,
              ),
            ),
          ),

          // Draggable Bottom Sheet
          _buildDraggableSheet(),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet() {
    final provider = widget.selectedProvider;
    
    return DraggableScrollableSheet(
      initialChildSize: _isBookingSuccess ? 0.6 : 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFF3DE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            image: DecorationImage(
              image: AssetImage('assets/images/medic_pattern3.png'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.brown[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Status Section
                      _buildStatusSection(),
                      
                      const SizedBox(height: 25),
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
                      if (!_isBooking && !_isBookingSuccess)
                        _buildActionButtons(),
                      
                      // Loading indicator saat booking
                      if (_isBooking && !_isBookingSuccess)
                        _buildLoadingState(),
                      
                      // Success state
                      if (_isBookingSuccess && _bookingResult != null)
                        _buildSuccessState(),
                      
                      // Error message
                      if (_bookingError != null && !_isBooking)
                        _buildErrorState(),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusSection() {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFD4A843),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.info, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Konfirmasi Pemesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Silakan periksa kembali detail pemesanan Anda",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Confirm Button
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
        
        // Cancel Button
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

  Widget _buildLoadingState() {
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
                  children: const [
                    Text(
                      "Sedang memproses...",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Jangan tutup aplikasi",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pesanan Berhasil!",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Booking ID: ${_bookingResult!['id']}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate ke tracking screen atau home
              // Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti dengan HomeScreen Anda
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4503A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Kembali ke Beranda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _bookingError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
            child: const Text("Coba Lagi"),
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
            child: const Text("Batalkan"),
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
        providerId: widget.selectedProvider.id,
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

      if (mounted) {
        setState(() {
          _isBooking = false;
          _isBookingSuccess = true;
          _bookingResult = result;
        });
        
        print('✅ Booking successful! Booking ID: ${result['id']}');
      }
      
    } catch (e) {
      print('❌ Booking failed: $e');
      
      if (mounted) {
        setState(() {
          _isBooking = false;
          _bookingError = e.toString();
        });
      }
    }
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
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Kembali ke screen sebelumnya
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientConditionInfo() {
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
            child: const Center(
              child: Icon(Icons.medical_information, size: 22, color: Color(0xFFD4503A)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kondisi Pasien',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.patientCondition.isEmpty 
                      ? 'Tidak disebutkan' 
                      : widget.patientCondition,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        provider.address,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      provider.phone,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
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
          children: const [
            Icon(Icons.payments_outlined, color: Color(0xFF9E5C11)),
            SizedBox(width: 10),
            Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const Text(
          "Rp300.000",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4503A)),
        ),
      ],
    );
  }
}
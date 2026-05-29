import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../screens/tracking/tracking_screen.dart';
import '../../schema/location.dart';
import '../../schema/provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class OrderProcessingScreen extends StatefulWidget {
  final Provider selectedProvider;
  final LocationData? pickupLocation;
  final LocationData? destinationLocation;

  const OrderProcessingScreen({
    super.key,
    required this.selectedProvider,
    this.pickupLocation,
    this.destinationLocation,
  });

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  bool _isConnecting = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _simulateConnection();
  }

  void _simulateConnection() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _isConnected = true;
        });
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

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
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
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
      initialChildSize: _isConnected ? 0.5 : 0.4,
      minChildSize: 0.25,
      maxChildSize: 0.65,
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

                      // Provider Info Section
                      _buildProviderInfo(provider),
                      
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFCC9E60), thickness: 0.5),
                      const SizedBox(height: 15),

                      // Price Info (coming soon)
                      _buildPriceInfo(),
                      
                      const SizedBox(height: 20),
                      
                      // Cancel Button
                      _buildCancelButton(),
                      
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
    if (_isConnecting) {
      return Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9E5C11)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Menghubungi Provider...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Pesanan Anda sedang diproses",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Provider Ditemukan!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Text(
                  "Menunggu konfirmasi driver",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      );
    }
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

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isConnecting ? _cancelOrder : null,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: _isConnecting ? Colors.white : Colors.grey.shade100,
        ),
        child: Text(
          "Batalkan Pesanan",
          style: TextStyle(
            color: _isConnecting ? Colors.red : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
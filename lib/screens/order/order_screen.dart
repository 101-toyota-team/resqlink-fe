import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/order_map_preview.dart'; 
import 'ambulance_selection_screen.dart';
import '../../schema/location.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  // Simpan LocationData lengkap
  LocationData _pickupLocation = LocationData(
    address: "",
    latitude: 0.0,
    longitude: 0.0,
    h3Index: "",
  );

  LocationData _destinationLocation = LocationData(
    address: "",
    latitude: 0.0,
    longitude: 0.0,
    h3Index: "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Bagian Atas
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/resqlink-banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            // Konten Utama dengan Offset ke Atas
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    
                    OrderMapPreview(
                      onLocationChanged: (pickup, destination) {
                        setState(() {
                          _pickupLocation = pickup;
                          _destinationLocation = destination;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    const PatientConditionWidget(),
                    const SizedBox(height: 32),
                    
                    GradientButton(
                      title: "Lanjut",
                      onPressed: () {
                        // Validasi lokasi sudah dipilih
                        if (_pickupLocation.address.isEmpty || _destinationLocation.address.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silakan pilih lokasi jemput dan tujuan terlebih dahulu'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        
                        // Kirim LocationData ke AmbulanceSelectionScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AmbulanceSelectionScreen(
                              pickupLocation: _pickupLocation,
                              destinationLocation: _destinationLocation,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),







                    // Debug panel
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Debug Lokasi',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pickup: ${_pickupLocation.address.isNotEmpty ? _pickupLocation.address : "Belum dipilih"}',
                            style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Dest: ${_destinationLocation.address.isNotEmpty ? _destinationLocation.address : "Belum dipilih"}',
                            style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_pickupLocation.latitude != 0.0) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Pickup Lat/Lng: ${_pickupLocation.latitude.toStringAsFixed(6)}/${_pickupLocation.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                          if (_pickupLocation.h3Index != NullableIndexedWidgetBuilder) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Pickup H3: ${_pickupLocation.h3Index}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace'),
                            ),
                          ],
                          if (_destinationLocation.latitude != 0.0) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Dest Lat/Lng: ${_destinationLocation.latitude.toStringAsFixed(6)}/${_destinationLocation.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
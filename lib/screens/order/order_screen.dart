import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/order_map_preview.dart'; 
import 'ambulance_selection_screen.dart';
import '../../schema/location.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  LocationData? _pickupLocation;
  LocationData? _destinationLocation;
  
  String _patientCondition = "";
  bool _showDebug = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
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
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pesan Ambulan',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.white,
                          fontSize: 28,
                          shadows: [
                            const Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lengkapi data untuk bantuan medis',
                        style: AppTypography.bodyWhite.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          shadows: [
                            const Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Konten Utama dengan Offset ke Atas
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: OrderMapPreview(
                        onLocationChanged: (pickup, destination) {
                          setState(() {
                            _pickupLocation = pickup;
                            _destinationLocation = destination;
                          });
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    PatientConditionWidget(
                      onConditionChanged: (description) {
                        setState(() {
                          _patientCondition = description;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: GradientButton(
                        title: "Lanjut ke Pilih Armada",
                        onPressed: () {

                          if (_pickupLocation == null || _pickupLocation!.address.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Silakan pilih lokasi jemput terlebih dahulu'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          
                          if (_destinationLocation == null || _destinationLocation!.address.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Silakan pilih lokasi tujuan terlebih dahulu'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          
                          if (_patientCondition.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Silakan isi deskripsi kondisi pasien terlebih dahulu'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AmbulanceSelectionScreen(
                                pickupLocation: _pickupLocation!,
                                destinationLocation: _destinationLocation!,
                                patientCondition: _patientCondition,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Debug Toggle
                    GestureDetector(
                      onLongPress: () => setState(() => _showDebug = !_showDebug),
                      child: Container(height: 20, width: double.infinity, color: Colors.transparent),
                    ),

                    if (_showDebug)
                      _buildDebugPanel(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SYSTEM DEBUG INFO',
                style: AppTypography.label.copyWith(fontWeight: FontWeight.w800, color: Colors.blueGrey),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => setState(() => _showDebug = false),
              ),
            ],
          ),
          const Divider(),
          _debugRow('Pickup', _pickupLocation?.address ?? 'Belum dipilih'),
          _debugRow('Destination', _destinationLocation?.address ?? 'Belum dipilih'),
          _debugRow('Condition', _patientCondition.isEmpty ? 'Belum diisi' : _patientCondition),
          _debugRow('H3 Index', _pickupLocation?.h3Index ?? '-'),
          _debugRow('Lat/Lng', _pickupLocation != null 
              ? '${_pickupLocation!.latitude.toStringAsFixed(6)}, ${_pickupLocation!.longitude.toStringAsFixed(6)}' 
              : '-'),
        ],
      ),
    );
  }

  Widget _debugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.captionSmall.copyWith(fontWeight: FontWeight.bold)),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
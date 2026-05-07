import 'package:flutter/material.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/order/nearest_hospital.dart';

class SelectDestinationScreen extends StatefulWidget {
  const SelectDestinationScreen({super.key});

  @override
  State<SelectDestinationScreen> createState() => _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  bool _showHospitalSuggestions = false;
  
  // Controller untuk menangkap teks yang diketik
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  void _handleHospitalFocusChanged(bool hasFocus) {
    setState(() {
      _showHospitalSuggestions = hasFocus;
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

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

            // Konten Form
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    LocationSelector(
                      onHospitalFocusChanged: _handleHospitalFocusChanged,
                      pickupController: _pickupController,
                      destinationController: _destinationController,
                    ),
                    const SizedBox(height: 24),

                    if (_showHospitalSuggestions)
                      const NearestHospitalWidget(
                        hospitals: [
                          HospitalItem(name: 'RS Bunda Margonda', distance: '1,5 km dari lokasi Anda', isNearest: true),
                          HospitalItem(name: 'RS Mitra Keluarga', distance: '2,6 km dari lokasi Anda'),
                          HospitalItem(name: 'RS Hermina Depok', distance: '3,2 km dari lokasi Anda'),
                        ],
                      ),
                    
                    const SizedBox(height: 32),

                    GradientButton(
                      title: "Oke",
                      onPressed: () {
                        // Balik ke OrderScreen sambil bawa data
                        Navigator.pop(context, {
                          'pickup': _pickupController.text,
                          'destination': _destinationController.text,
                        });
                      },
                    ),
                    const SizedBox(height: 20),
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
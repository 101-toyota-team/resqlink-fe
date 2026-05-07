import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/location_selector.dart';
import 'pilih_tujuan.dart';
import 'ambulance_selection_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String pickupLocation = "";
  String destinationLocation = "";

  void _navigateToSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectDestinationScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        pickupLocation = result['pickup'] ?? "";
        destinationLocation = result['destination'] ?? "";
      });
    }
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

            // Konten Utama dengan Offset ke Atas
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Map Placeholder & Selector
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text("Map Placeholder"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: _navigateToSelection,
                            child: AbsorbPointer(
                              child: LocationSelector(
                                initialPickup: pickupLocation,
                                initialDestination: destinationLocation,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const PatientConditionWidget(),
                    const SizedBox(height: 32),
                    GradientButton(
                      title: "Lanjut",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AmbulanceSelectionScreen()),
                        );
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
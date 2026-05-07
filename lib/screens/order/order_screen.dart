import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/location_selector.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Scroll agar aman
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
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
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Layer Bawah: Placeholder Map
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text("Map Placeholder", style: TextStyle(color: Colors.grey)),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: LocationSelector(),
                      ),
                    ],
                  ),
                  // --- END AREA STACK ---

                  const SizedBox(height: 24),

                  const PatientConditionWidget(),

                  const SizedBox(height: 32),

                  GradientButton(
                    title: "Lanjut",
                    onPressed: () => print("Lanjut!"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
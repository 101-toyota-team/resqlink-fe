import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/order_map_preview.dart'; 
import 'ambulance_selection_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String finalPickup = "";
  String finalDestination = "";

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
                        // Menampung koordinat/string lokasi dari widget peta
                        finalPickup = pickup;
                        finalDestination = destination;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    const PatientConditionWidget(),
                    const SizedBox(height: 32),
                    
                    GradientButton(
                      title: "Lanjut",
                      onPressed: () {
                        // Di sini kamu bisa melempar data finalPickup dan finalDestination ke screen berikutnya jika diperlukan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AmbulanceSelectionScreen(),
                          ),
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
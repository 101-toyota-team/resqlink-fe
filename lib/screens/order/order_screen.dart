import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              // Banner Image
              Container(
                width: double.infinity,
                height: 220, 
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/resqlink-banner.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Tombol Back
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
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ],
          ),

          // Bagian Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const PatientConditionWidget(),
                  const Spacer(), 
                  GradientButton(
                    title: "Lanjut",
                    onPressed: () {
                      print("Tombol Lanjut ditekan");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';
import '../../widgets/common/gradient_button.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
    );
  }
}
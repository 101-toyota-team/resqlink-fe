import 'package:flutter/material.dart';
import '../../widgets/order/patient_condition.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: PatientConditionWidget(),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../widgets/tracking/travel_status.dart';
import '../../widgets/tracking/eta_info.dart';
import '../../widgets/tracking/driver_section.dart';


class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Status Perjalanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TravelStatusWidget(),
            const SizedBox(height: 20),
            // Placeholder Map
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(child: Text("Map Placeholder")),
            ),
            const SizedBox(height: 20),
            const EtaInfoWidget(),
            const SizedBox(height: 20),
            const DriverSectionWidget(),
          ],
        ),
      ),
    );
  }
}
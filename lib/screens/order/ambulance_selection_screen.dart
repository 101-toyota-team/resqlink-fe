import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/order/ambulance_card.dart';
import '../../widgets/common/gradient_button.dart';

class AmbulanceSelectionScreen extends StatelessWidget {
  const AmbulanceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DE),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6, 
            color: Colors.grey[300],
            child: const Center(
              child: Text("Map Placeholder", style: TextStyle(color: Colors.grey)),
            ),
          ),

          Positioned(
            top: 50,
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

          const Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: 0.9,
              child: LocationSelector(), 
            ),
          ),

        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3DE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Handle Bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.brown[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pilih Ambulan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController, 
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 5, 
                        itemBuilder: (context, index) {
                          return const AmbulanceCard(
                            name: "RS Bunda Margonda",
                            distance: "1,2 km",
                            duration: "6-8 menit",
                            price: "Rp300.000",
                            treatment: "Dengan Perawatan",
                          );
                        },
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GradientButton(
                      title: "Pesan Ambulan",
                      onPressed: () {
                        print("Lanjut ke pembayaran/konfirmasi");
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ],
      ),
    );
  }
}



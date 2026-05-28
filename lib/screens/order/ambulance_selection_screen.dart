import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/order/ambulance_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../screens/order/order_processing_screen.dart';
import '../../screens/tracking/tracking_screen.dart';
import '../../services/nearby_provider_service.dart';
import '../../services/auth_helper.dart';
import '../../widgets/order/ambulance_detail_bottom_sheet.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'; // Tambahkan import Mapbox core

class ProviderItem {
  final String name;
  final String distance;

  const ProviderItem({
    required this.name,
    required this.distance,
  });
}


class AmbulanceSelectionScreen extends StatefulWidget {
  const AmbulanceSelectionScreen({super.key});

  @override
  State<AmbulanceSelectionScreen> createState() => _AmbulanceSelectionScreenState();
}


class _AmbulanceSelectionScreenState extends State<AmbulanceSelectionScreen> {
  final NearbyProviderService _nearbyService = NearbyProviderService();
  List<ProviderItem> _providers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNearbyProviders();
  }
  
  Future<void> _fetchNearbyProviders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = AuthHelper.token;
      
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }

      print('🔄 Fetching nearby providers...');
      
      final result = await _nearbyService.getNearbyProviders(token);
      
      print('✅ API Response received: $result');
      print('Response type: ${result.runtimeType}'); // Debug: see what type we got

      // Handle different response formats
      List<dynamic> providersData = [];
      
      // Case 1: Response is an empty array
      if (result is List) {
        providersData = result;
        print('Response is a List, length: ${result.length}');
      }
      // Case 2: Response is a Map/object with 'data' field
      // else if (result is Map<String, dynamic>) {
      //   if (result.containsKey('data')) {
      //     providersData = result['data'] is List ? result['data'] : [];
      //     print('Found data field with ${providersData.length} items');
      //   } else if (result.containsKey('providers')) {
      //     providersData = result['providers'] is List ? result['providers'] : [];
      //     print('Found providers field with ${providersData.length} items');
      //   } else {
      //     // Try to use the map values
      //     providersData = result.values.whereType<List>().expand((e) => e).toList();
      //     print('Extracted ${providersData.length} items from map values');
      //   }
      // }
      else {
        print('Unknown response format: ${result.runtimeType}');
        providersData = [];
      }

      // Convert to providerItem objects safely
      final List<ProviderItem> fetchedProviders = [];
      
      for (var i = 0; i < providersData.length; i++) {
        final provider = providersData[i];
        
        // Safely extract values with null checks
        final name = provider['name'] ?? 
                    'Unknown provider';
                    
        // Handle distance (could be string, int, double, or null)
        String distanceText = 'Distance unknown';
        final distanceValue = provider['distance'];
        
        if (distanceValue != null) {
          try {
            distanceText = '$distanceValue km dari lokasi Anda';
          } catch (e) {
            print('Error parsing distance: $e');
          }
        }
        
        fetchedProviders.add(
          ProviderItem(
            name: name,
            distance: distanceText,
          ),
        );
      }

      setState(() {
        _providers = fetchedProviders;
        _isLoading = false;
      });

      print('✅ Loaded ${fetchedProviders.length} nearby providers');

      if (fetchedProviders.isEmpty) {
        print('⚠️ No providers found nearby');
      }

    } catch (e, stackTrace) {
      print('❌ Error fetching nearby providers: $e');
      print('Stack trace: $stackTrace');
      
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _providers = [];
      });
    }
  }

  // void _showAmbulanceDetail(BuildContext context, ProviderItem provider) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.75,
  //       minChildSize: 0.5,
  //       maxChildSize: 0.9,
  //       builder: (context, scrollController) => AmbulanceDetailBottomSheet(
  //         name: provider.name,
  //         distance: provider.distance,
  //         duration: '6-8 menit', // Ganti dengan data real nanti
  //         price: 'Rp300.000', // Ganti dengan data real nanti
  //         treatment: 'Dengan Perawatan lengkap + Oksigen',
  //         phoneNumber: '(021) 50950888',
  //         providerType: 'Rumah Sakit',
  //         address: 'Jl. Contoh Alamat No. 123',
  //       ),
  //     ),
  //   );
  // }

  void _showAmbulanceDetail(BuildContext context, ProviderItem provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => AmbulanceDetailBottomSheet(
          name: provider.name,
          distance: provider.distance,
          duration: '6-8 menit',
          price: 'Rp300.000',
          treatment: 'Dengan Perawatan lengkap + Oksigen',
          phoneNumber: '(021) 50950888',
          providerType: 'Rumah Sakit',
          address: 'Jl. Contoh Alamat No. 123, Jakarta',
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DE),
      body: Stack(
        children: [
          // ========================================================
          // PENGGANTI MAP PLACEHOLDER (Menggunakan Peta Mapbox Aktif)
          // ========================================================
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6, 
            child: MapWidget(
              key: const ValueKey("selectionMapboxWidget"),
              styleUri: MapboxStyles.MAPBOX_STREETS, // Menggunakan style streets ojol
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(106.816666, -6.200000)), // Default Jakarta
                zoom: 14.0,
              ),
              onMapCreated: (mapboxMap) {
                // Sembunyikan aksesoris kompas bawaan Mapbox agar visual layar bersih
                mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
              },
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
                  image: DecorationImage(
                    image: AssetImage('assets/images/medic_pattern3.png'),
                    fit: BoxFit.cover,
                  ),
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

                    // Expanded(
                    //   child: ListView.builder(
                    //     controller: scrollController, 
                    //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    //     itemCount: _providers.length,
                    //     itemBuilder: (context, index) {
                    //       final provider = _providers[index];
                    //       return AmbulanceCard(
                    //         name: provider.name, // Use provider's name
                    //         distance: provider.distance, // Use provider's distance
                    //         duration: '<placeholder>', // Optional: calculate from distance
                    //         price: '<placeholder>', // Optional: calculate based on distance
                    //         treatment: '<placeholder>', // Or make this dynamic if available
                    //       );
                    //     },
                    //   ),
                    // ),

                    Expanded(
                        child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _providers.length,
                        itemBuilder: (context, index) {
                          final provider = _providers[index];
                          return AmbulanceCard(
                            name: provider.name,
                            distance: provider.distance,
                            duration: '6-8 menit',
                            price: 'Rp300.000',
                            treatment: 'Dengan Perawatan',
                            isNearest: index == 0, // Provider pertama dianggap terdekat
                            onTap: () {
                              _showAmbulanceDetail(context, provider);
                            },
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GradientButton(
                        title: "Pesan Ambulan",
                        onPressed: () {
                          Navigator.push(
                            context,
                            // MaterialPageRoute(builder: (context) => const TrackingScreen()),
                            MaterialPageRoute(builder: (context) => const OrderProcessingScreen()),
                          );
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
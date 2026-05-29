import 'package:flutter/material.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/order/ambulance_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../screens/order/order_processing_screen.dart';
import '../../services/nearby_provider_service.dart';
import '../../services/auth_helper.dart';
import '../../widgets/order/ambulance_detail_bottom_sheet.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../schema/location.dart';

class ProviderItem {
  final String name;
  final String distance;
  final double? latitude;
  final double? longitude;
  final String? h3Index;
  final String? phone;
  final String? address;

  const ProviderItem({
    required this.name,
    required this.distance,
    this.latitude,
    this.longitude,
    this.h3Index,
    this.phone,
    this.address,
  });
}

class AmbulanceSelectionScreen extends StatefulWidget {
  final LocationData pickupLocation;
  final LocationData destinationLocation;

  const AmbulanceSelectionScreen({
    super.key,
    required this.pickupLocation,
    required this.destinationLocation,
  });

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
      print('📍 Pickup Location: ${widget.pickupLocation.address}');
      print('📍 Pickup Lat/Lng: ${widget.pickupLocation.latitude}, ${widget.pickupLocation.longitude}');
      print('🔢 Pickup H3: ${widget.pickupLocation.h3Index}');
      
      // Fetch providers based on pickup location
      final result = await _nearbyService.getNearbyProviders(
        token, 
        h3Index: widget.pickupLocation.h3Index,
        latitude: widget.pickupLocation.latitude,
        longitude: widget.pickupLocation.longitude,
      );
      
      print('✅ API Response received: $result');
      print('Response type: ${result.runtimeType}');

      // Handle different response formats
      List<dynamic> providersData = [];
      
      if (result is List) {
        providersData = result;
        print('Response is a List, length: ${result.length}');
      } else if (result is Map<String, dynamic>) {
        if (result.containsKey('data')) {
          providersData = result['data'] is List ? result['data'] : [];
        } else if (result.containsKey('providers')) {
          providersData = result['providers'] is List ? result['providers'] : [];
        }
      }

      // Convert to ProviderItem objects
      final List<ProviderItem> fetchedProviders = [];
      
      for (var i = 0; i < providersData.length; i++) {
        final provider = providersData[i];
        
        final name = provider['name'] ?? 'Unknown provider';
        
        // Handle distance
        String distanceText = 'Distance unknown';
        final distanceValue = provider['distance'];
        if (distanceValue != null) {
          try {
            distanceText = distanceValue.toString().contains('km') 
                ? distanceValue.toString() 
                : '$distanceValue km dari lokasi Anda';
          } catch (e) {
            print('Error parsing distance: $e');
          }
        }
        
        fetchedProviders.add(
          ProviderItem(
            name: name,
            distance: distanceText,
            latitude: provider['latitude'] as double?,
            longitude: provider['longitude'] as double?,
            h3Index: provider['h3_index'] as String?,
            phone: provider['phone'] as String?,
            address: provider['address'] as String?,
          ),
        );
      }

      setState(() {
        _providers = fetchedProviders;
        _isLoading = false;
      });

      print('✅ Loaded ${fetchedProviders.length} nearby providers');

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
          phoneNumber: provider.phone ?? '(021) 50950888',
          providerType: 'Rumah Sakit',
          address: provider.address ?? 'Alamat tidak tersedia',
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
          // Map Widget
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6, 
            child: MapWidget(
              key: const ValueKey("selectionMapboxWidget"),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(
                  widget.pickupLocation.longitude != 0 
                      ? widget.pickupLocation.longitude 
                      : 106.816666,
                  widget.pickupLocation.latitude != 0 
                      ? widget.pickupLocation.latitude 
                      : -6.200000,
                )),
                zoom: 14.0,
              ),
              onMapCreated: (mapboxMap) {
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

          // Location Selector (Read-only)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: 0.9,
              child: LocationSelector(
                initialPickup: widget.pickupLocation.address,
                initialDestination: widget.destinationLocation.address,
                isReadOnly: true,
              ), 
            ),
          ),

          // Bottom Sheet with ambulance list
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

                    // Loading state
                    if (_isLoading)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Mencari provider ambulans terdekat...'),
                            ],
                          ),
                        ),
                      ),
                    
                    // Error state
                    if (!_isLoading && _errorMessage != null)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text('Error: $_errorMessage'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchNearbyProviders,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Empty state
                    if (!_isLoading && _errorMessage == null && _providers.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_hospital_outlined, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('Tidak ada provider ambulans ditemukan di sekitar Anda'),
                            ],
                          ),
                        ),
                      ),
                    
                    // List of ambulances
                    if (!_isLoading && _errorMessage == null && _providers.isNotEmpty)
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
                              isNearest: index == 0,
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
                            MaterialPageRoute(
                              builder: (context) => const OrderProcessingScreen(),
                            ),
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
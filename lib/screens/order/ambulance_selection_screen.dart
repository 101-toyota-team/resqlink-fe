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
import '../../schema/provider.dart';

class AmbulanceSelectionScreen extends StatefulWidget {
  final LocationData pickupLocation;
  final LocationData destinationLocation;
  final String patientCondition;

  const AmbulanceSelectionScreen({
    super.key,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.patientCondition,
  });

  @override
  State<AmbulanceSelectionScreen> createState() => _AmbulanceSelectionScreenState();
}

class _AmbulanceSelectionScreenState extends State<AmbulanceSelectionScreen> {
  final NearbyProviderService _nearbyService = NearbyProviderService();
  List<Provider> _providers = [];
  Provider? _selectedProvider;
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
      
      final result = await _nearbyService.getNearbyProviders(
        token, 
        h3Index: widget.pickupLocation.h3Index,
        latitude: widget.pickupLocation.latitude,
        longitude: widget.pickupLocation.longitude,
      );
      
      // Handle different response formats
      List<dynamic> providersData = [];
      
      if (result is List) {
        providersData = result;
      } else if (result is Map<String, dynamic>) {
        if (result.containsKey('data')) {
          providersData = result['data'] is List ? result['data'] : [];
        } else if (result.containsKey('providers')) {
          providersData = result['providers'] is List ? result['providers'] : [];
        }
      }

      // Convert to Provider objects using fromJson
      final List<Provider> fetchedProviders = [];
      
      for (var providerJson in providersData) {
        try {
          final provider = Provider.fromJson(providerJson);
          fetchedProviders.add(provider);
        } catch (e) {
          // Log and skip any provider that fails to parse
        }
      }

      setState(() {
        _providers = fetchedProviders;
        _isLoading = false;
      });

    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _providers = [];
      });
      
    }
  }

  void _selectProvider(Provider provider) {
    setState(() {
      _selectedProvider = provider;
    });
  }

  void _showAmbulanceDetail(Provider provider) {
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
          phoneNumber: provider.phone,
          providerType: provider.providerType,
          address: provider.address,
          onSelect: () {
            _selectProvider(provider);
          },
        ),
      ),
    );
  }

  void _confirmAndProceed() {
    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih provider ambulans terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderProcessingScreen(
          selectedProvider: _selectedProvider!,
          pickupLocation: widget.pickupLocation,
          destinationLocation: widget.destinationLocation,
          patientCondition: widget.patientCondition,
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
              viewport: CameraViewportState(
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

          // Back button
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

          // Bottom Sheet
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

                    // Selected Provider Summary (if any)
                    if (_selectedProvider != null)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A843).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD4A843), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFFD4A843), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ambulan Dipilih',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  Text(
                                    _selectedProvider!.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedProvider = null;
                                });
                              },
                              child: const Icon(Icons.close, size: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                    // Loading / Error / Empty / List states
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
                    
                    // List of ambulances with selection
                    if (!_isLoading && _errorMessage == null && _providers.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _providers.length,
                          itemBuilder: (context, index) {
                            final provider = _providers[index];
                            final isSelected = _selectedProvider?.id == provider.id;
                            
                            return AmbulanceCard(
                              name: provider.name,
                              distance: provider.distance,
                              duration: '6-8 menit',
                              price: 'Rp300.000',
                              treatment: 'Dengan Perawatan',
                              isNearest: index == 0,
                              isSelected: isSelected,
                              onTap: () => _showAmbulanceDetail(provider),
                              onSelect: () => _selectProvider(provider),
                            );
                          },
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GradientButton(
                        title: _selectedProvider != null 
                            ? "Pesan Ambulan" 
                            : "Pilih Ambulan Terlebih Dahulu",
                        onPressed: _confirmAndProceed,
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
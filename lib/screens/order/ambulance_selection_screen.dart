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
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../utils/error_handler.dart';
import '../../widgets/common/rq_error_state.dart';

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

      final List<Provider> fetchedProviders = [];
      
      for (var providerJson in providersData) {
        try {
          final provider = Provider.fromJson(providerJson);
          fetchedProviders.add(provider);
        } catch (e) {
          // Skip invalid data
        }
      }

      setState(() {
        _providers = fetchedProviders;
        _isLoading = false;
      });

    } catch (e) {
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
      backgroundColor: AppColors.secondary,
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
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
              ),
            ),
          ),

          // Location Selector (Read-only)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: 0.95,
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
                    opacity: 0.2,
                  ),
                ),
                child: Column(
                  children: [
                    // Handle Bar
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pilih Armada Ambulan",
                          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),

                    // Selected Provider Summary (if any)
                    if (_selectedProvider != null)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ARMADA DIPILIH',
                                    style: AppTypography.captionSmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedProvider!.name,
                                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _selectedProvider = null),
                              icon: const Icon(Icons.close, size: 20, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),

                    // States
                    if (_isLoading)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColors.primary),
                              SizedBox(height: 16),
                              Text('Mencari armada terdekat...'),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isLoading && _errorMessage != null)
                      Expanded(
                        child: RqErrorState(
                          fullScreen: false,
                          message: ErrorHandler.getErrorMessage(_errorMessage),
                          onRetry: _fetchNearbyProviders,
                        ),
                      ),
                    
                    if (!_isLoading && _errorMessage == null && _providers.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_hospital_outlined, size: 56, color: AppColors.textGrey),
                              SizedBox(height: 16),
                              Text('Tidak ada armada tersedia di sekitar Anda', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    
                    if (!_isLoading && _errorMessage == null && _providers.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _providers.length,
                          itemBuilder: (context, index) {
                            final provider = _providers[index];
                            final isSelected = _selectedProvider?.id == provider.id;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AmbulanceCard(
                                name: provider.name,
                                distance: provider.distance,
                                duration: '6-8 menit',
                                price: 'Rp300.000',
                                treatment: 'Dengan Perawatan',
                                isNearest: index == 0,
                                isSelected: isSelected,
                                onTap: () => _showAmbulanceDetail(provider),
                                onSelect: () => _selectProvider(provider),
                              ),
                            );
                          },
                        ),
                      ),

                    // Hanya tampilkan tombol konfirmasi jika tidak ada error dan tidak sedang loading
                    if (!_isLoading && _errorMessage == null && _providers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: GradientButton(
                            title: _selectedProvider != null 
                                ? "Konfirmasi Pesanan" 
                                : "Pilih Armada Terlebih Dahulu",
                            onPressed: _confirmAndProceed,
                          ),
                        ),
                      ),
                    
                    // Beri sedikit ruang di bawah jika dalam state error/empty agar tidak mentok
                    if (_errorMessage != null || _providers.isEmpty)
                      const SizedBox(height: 32),
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

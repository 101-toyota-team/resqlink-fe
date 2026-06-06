import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/nearby_provider_service.dart';
import '../../services/auth_helper.dart';
import '../../services/location_service.dart';
import '../../services/h3_helper.dart';
import '../../utils/error_handler.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../common/rq_error_state.dart';

class HospitalItem {
  final String name;
  final String distance;
  final bool isNearest;

  const HospitalItem({
    required this.name,
    required this.distance,
    this.isNearest = false,
  });
}

class NearestHospitalWidget extends StatefulWidget {
  final String? h3Index;
  final double? latitude;
  final double? longitude;
  
  const NearestHospitalWidget({
    super.key,
    this.h3Index,
    this.latitude,
    this.longitude,
  });

  @override
  State<NearestHospitalWidget> createState() => _NearestHospitalWidgetState();
}

class _NearestHospitalWidgetState extends State<NearestHospitalWidget> {
  final NearbyProviderService _nearbyService = NearbyProviderService();
  final LocationService _locationService = LocationService();
  List<HospitalItem> _hospitals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNearbyHospitals();
  }
 
  Future<void> _fetchNearbyHospitals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = AuthHelper.token;
      
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }      
      String h3Index;
      double latitude;
      double longitude;
      
      // Gunakan parameter dari widget jika ada
      if (widget.h3Index != null && widget.h3Index!.isNotEmpty) {
        h3Index = widget.h3Index!;
        latitude = widget.latitude ?? 0;
        longitude = widget.longitude ?? 0;
      } else {
        // Fallback: ambil lokasi dari device
        final position = await _locationService.getUserLocation();
        latitude = position.latitude;
        longitude = position.longitude;
        h3Index = await H3Helper.generateH3Index(latitude, longitude);
      }
      
      final result = await _nearbyService.getNearbyProviders(
        token,
        h3Index: h3Index,
        latitude: latitude,
        longitude: longitude,
      );
    

      // Handle different response formats
      List<dynamic> hospitalsData = [];
      
      if (result is List) {
        hospitalsData = result;
      } else if (result is Map<String, dynamic>) {
        if (result.containsKey('data')) {
          hospitalsData = result['data'] is List ? result['data'] : [];
        } else if (result.containsKey('hospitals')) {
          hospitalsData = result['hospitals'] is List ? result['hospitals'] : [];
        } else {
          hospitalsData = [];
        }
      }

      // Convert to HospitalItem objects
      final List<HospitalItem> fetchedHospitals = [];
      
      for (var i = 0; i < hospitalsData.length; i++) {
        final hospital = hospitalsData[i];
        
        // Safely extract values with null checks
        final name = hospital['name'] ?? 
                    hospital['hospital_name'] ?? 
                    hospital['nama_rs'] ?? 
                    'Unknown Hospital';
                    
        // Handle distance (could be string, int, double, or null)
        String distanceText = 'Distance unknown';
        final distanceValue = hospital['distance_km'] ?? hospital['distance'];
        
        if (distanceValue != null) {
          try {
            double distInKm;
            if (distanceValue is String) {
              distInKm = double.parse(distanceValue);
            } else if (distanceValue is int || distanceValue is double) {
              distInKm = distanceValue.toDouble();
            } else {
              distInKm = 0.0;
            }
            distanceText = '${distInKm.toStringAsFixed(1)} km dari lokasi Anda';
          } catch (e) {
            distanceText = 'Jarak tidak diketahui';
          }
        }
        
        fetchedHospitals.add(
          HospitalItem(
            name: name,
            distance: distanceText,
            isNearest: i == 0, // First item is nearest if sorted by distance
          ),
        );
      }

      setState(() {
        _hospitals = fetchedHospitals;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _hospitals = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rekomendasi RS Terdekat',
          style: AppTypography.title.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),

        // Loading state
        if (_isLoading)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider, width: 1.5),
            ),
            child: Column(
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Mencari rumah sakit terdekat...',
                  style: AppTypography.caption.copyWith(color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        
        // Error state
        if (!_isLoading && _errorMessage != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider, width: 1.5),
            ),
            child: RqErrorState(
              fullScreen: false,
              message: ErrorHandler.getErrorMessage(_errorMessage),
              onRetry: _fetchNearbyHospitals,
            ),
          ),
        
        // Empty state
        if (!_isLoading && _errorMessage == null && _hospitals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider, width: 1.5),
            ),
            child: Column(
              children: [
                const Icon(Icons.local_hospital_outlined, size: 48, color: AppColors.textGrey),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada rumah sakit ditemukan di sekitar Anda',
                  style: AppTypography.body.copyWith(color: AppColors.textGrey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        
        // Success state with hospitals list
        if (!_isLoading && _errorMessage == null && _hospitals.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.divider,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: List.generate(_hospitals.length, (index) {
                final hospital = _hospitals[index];
                final isLast = index == _hospitals.length - 1;
                return Column(
                  children: [
                    HospitalTile(hospital: hospital),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }
}

// HospitalTile remains the same
class HospitalTile extends StatelessWidget {
  final HospitalItem hospital;

  const HospitalTile({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Hospital Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.kitMedical,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & Distance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital.name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  hospital.distance,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),

          // "Terdekat" Badge (only for the nearest hospital)
          if (hospital.isNearest) ...[
            const SizedBox(width: 8),
            const _NearestBadge(),
          ],
        ],
      ),
    );
  }
}

class _NearestBadge extends StatelessWidget {
  const _NearestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.amber,
          width: 1.5,
        ),
      ),
      child: Text(
        'Terdekat',
        style: AppTypography.captionSmall.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.amber,
        ),
      ),
    );
  }
}
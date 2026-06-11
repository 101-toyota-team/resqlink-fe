import 'package:flutter/material.dart';
import '../../services/nearby_provider_service.dart';
import '../../services/auth_helper.dart';
import '../../services/location_service.dart';
import '../../services/h3_helper.dart';
import '../../utils/error_handler.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../common/rq_error_state.dart';

class HospitalItem {
  final String id;
  final String name;
  final String distance;
  final String address;
  final bool isNearest;
  final Map<String, dynamic> rawData;

  const HospitalItem({
    required this.id,
    required this.name,
    required this.distance,
    required this.address,
    required this.rawData,
    this.isNearest = false,
  });
}

class NearestHospitalWidget extends StatefulWidget {
  final String? h3Index;
  final double? latitude;
  final double? longitude;
  final ValueChanged<Map<String, dynamic>> onHospitalSelected;
  
  const NearestHospitalWidget({
    super.key,
    this.h3Index,
    this.latitude,
    this.longitude,
    required this.onHospitalSelected,
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
    _loadNearestHospitals();
  }

  @override
  void didUpdateWidget(covariant NearestHospitalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.h3Index != widget.h3Index ||
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _loadNearestHospitals();
    }
  }

  Future<void> _loadNearestHospitals() async {
    if (!mounted) return;
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

      // if (result['status'] == 'success' && result['data'] != null) {
        // Handle different response formats
        List<dynamic> providers = [];
        
        if (result is List) {
          providers = result;
        } else if (result is Map<String, dynamic>) {
          if (result.containsKey('data')) {
            providers = result['data'] is List ? result['data'] : [];
          } else if (result.containsKey('hospitals')) {
            providers = result['hospitals'] is List ? result['hospitals'] : [];
          } else {
            providers = [];
          }
        }
        
        // final List<dynamic> providers = result['data'];
        
        final List<HospitalItem> mapped = [];
        for (int i = 0; i < providers.length; i++) {
          final p = providers[i];
          
          // double distKm = 0.0;
          // if (p['distance_meters'] != null) {
          //   distKm = (p['distance_meters'] as num).toDouble() / 1000.0;
          // }

          mapped.add(HospitalItem(
            id: p['id']?.toString() ?? '',
            name: p['name'] ?? 'Unknown Hospital',
            distance: p['distance'] ?? 'Unknown distance',
            address: p['address'] ?? 'Indonesia',
            isNearest: i == 0, // Item pertama adalah yang terdekat
            rawData: p, // Menyimpan full object map untuk dikirim ke pilih_tujuan
          ));
        }

        if (mounted) {
          setState(() {
            _hospitals = mapped;
            _isLoading = false;
          });
        }
      // } else {
      //   throw Exception(result['message'] ?? "Failed to load nearest hospitals.");
      // }
    } catch (e) {
      if (mounted) {
        setState(() {
          debugPrint('[Error] Failed to load nearest hospitals: $e');
          _errorMessage = ErrorHandler.getErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return RqErrorState(
        message: _errorMessage!,
        onRetry: _loadNearestHospitals,
      );
    }

    if (_hospitals.isEmpty) {
      return const Padding(
        child: Text("Tidak ada rumah sakit di sekitar Anda", style: TextStyle(color: Colors.grey)),
        padding: EdgeInsets.all(20.0),
      );
    }

    // Mengubah ListView.builder menggunakan ListTile agar strukturnya sama persis dengan panel hasil pencarian
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _hospitals.length,
      itemBuilder: (context, index) {
        final hospital = _hospitals[index];
        
        return ListTile(
          leading: const Icon(Icons.local_hospital_rounded, color: Color(0xFFCC9E60)),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  hospital.name, 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hospital.isNearest) ...[
                const SizedBox(width: 8),
                const _NearestBadge(),
              ]
            ],
          ),
          subtitle: Text(
            "${hospital.address} (${hospital.distance})", 
            style: const TextStyle(fontSize: 12, color: Colors.grey), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            widget.onHospitalSelected(hospital.rawData);
          },
        );
      },
    );
  }
}

class _NearestBadge extends StatelessWidget {
  const _NearestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.amber,
          width: 1.2,
        ),
      ),
      child: const Text(
        'Terdekat',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.amber,
        ),
      ),
    );
  }
}
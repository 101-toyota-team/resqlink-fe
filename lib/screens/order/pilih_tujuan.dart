import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/nearest_hospital.dart'; 
import '../../services/auth_helper.dart';
import '../../services/location_service.dart';
import '../../schema/location.dart';
import '../../services/h3_helper.dart';
import '../../themes/app_colors.dart';

class SelectDestinationScreen extends StatefulWidget {
  final LocationData? initialPickup;
  final LocationData? initialDestination;
  final String? pickupHint;
  final String? destinationHint;

  const SelectDestinationScreen({
    super.key,
    this.initialPickup,
    this.initialDestination,
    this.pickupHint,
    this.destinationHint,
  });

  @override
  State<SelectDestinationScreen> createState() => _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  
  double? _selectedPickupLat;
  double? _selectedPickupLng;
  String? _selectedPickupH3;

  double? _selectedDestinationLat;
  double? _selectedDestinationLng;
  String? _selectedDestinationH3;

  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode(); 

  MapboxMap? _mapboxMap;
  List<dynamic> _mapboxPredictions = []; 
  List<dynamic> _destinationMapboxPredictions = []; // Baru: untuk Custom Hint flow (Jenazah, Welcab, dll)
  List<dynamic> _hospitalPredictions = []; 

  late String _sessionToken;
  
  // Loading state untuk location
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize from LocationData if available
    if (widget.initialPickup != null) {
      _pickupController.text = widget.initialPickup!.address;
      _selectedPickupLat = widget.initialPickup!.latitude;
      _selectedPickupLng = widget.initialPickup!.longitude;
      _selectedPickupH3 = widget.initialPickup!.h3Index;
    }
    
    if (widget.initialDestination != null) {
      _destinationController.text = widget.initialDestination!.address;
      _selectedDestinationLat = widget.initialDestination!.latitude;
      _selectedDestinationLng = widget.initialDestination!.longitude;
      _selectedDestinationH3 = widget.initialDestination!.h3Index;
    }
    
    _sessionToken = DateTime.now().millisecondsSinceEpoch.toString();

    _destinationFocusNode.addListener(() => setState(() {}));
    _pickupFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
  }

  // Method untuk mendapatkan lokasi user saat ini
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final locationService = LocationService();
      final position = await locationService.getUserLocation();
          
      // Simpan koordinat pickup
      _selectedPickupLat = position.latitude;
      _selectedPickupLng = position.longitude;
      
      // Generate H3 index untuk pickup
      _selectedPickupH3 = await H3Helper.generateH3Index(position.latitude, position.longitude);      
      // Reverse geocoding: Convert lat/lng to address using Mapbox
      await _reverseGeocodeAndSetPickup(position.latitude, position.longitude);
      
      // Optional: Move map camera to user location
      if (_mapboxMap != null) {
        await _mapboxMap?.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(position.longitude, position.latitude)),
            zoom: 15.0,
          ),
          MapAnimationOptions(duration: 1000),
        );
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendapatkan lokasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }
  
  // Reverse geocoding menggunakan Mapbox API
  Future<void> _reverseGeocodeAndSetPickup(double lat, double lng) async {
    final String mapboxToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    final String url = "https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$mapboxToken&language=id";
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'];
        
        if (features != null && features.isNotEmpty) {
          final placeName = features[0]['place_name'] ?? '';
          final address = features[0]['text'] ?? '';
          
          setState(() {
            _pickupController.text = placeName.isNotEmpty ? placeName : address;
          });
          
        } else {
          setState(() {
            _pickupController.text = "Lokasi Saat Ini ($lat, $lng)";
          });
        }
      } else {
        setState(() {
          _pickupController.text = "Lokasi Saat Ini ($lat, $lng)";
        });
      }
    } catch (e) {
      setState(() {
        _pickupController.text = "Lokasi Saat Ini ($lat, $lng)";
      });
    }
  }

  // 1. PENCARIAN TEMPAT (Mapbox API)
  Future<void> searchPlaces(String query, {bool isPickup = true}) async {
    if (query.isEmpty) {
      setState(() {
        if (isPickup) _mapboxPredictions = [];
        else _destinationMapboxPredictions = [];
      });
      return;
    }
    if (query.length < 3) return;

    final String mapboxToken = dotenv.env['MAPBOX_TOKEN'] ?? ""; 
    final String url = "https://api.mapbox.com/search/searchbox/v1/suggest?q=${Uri.encodeComponent(query)}&country=id&language=id&access_token=$mapboxToken&session_token=$_sessionToken";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (isPickup) {
            _mapboxPredictions = data['suggestions'] ?? [];
          } else {
            _destinationMapboxPredictions = data['suggestions'] ?? [];
          }
        });
      }
    } catch (e) {
      debugPrint("Error Mapbox: $e");
    }
  }

  // Method untuk memilih suggestion (dengan fetch detail)
  Future<void> _selectPlaceSuggestion(Map<String, dynamic> item, {bool isPickup = true}) async {
    final mainText = item['name'] ?? "";
    final secondaryText = item['full_address'] ?? item['place_formatted'] ?? "";
    final fullAddress = secondaryText.isNotEmpty ? "$mainText, $secondaryText" : mainText;
    
    setState(() {
      if (isPickup) {
        _pickupController.text = fullAddress;
        _mapboxPredictions = [];
      } else {
        _destinationController.text = fullAddress;
        _destinationMapboxPredictions = [];
      }
    });
    
    if (isPickup) _pickupFocusNode.unfocus();
    else _destinationFocusNode.unfocus();
    
    final mapboxToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    final mapboxId = item['mapbox_id'];
    
    if (mapboxId != null && mapboxId.isNotEmpty) {
      final detailUrl = "https://api.mapbox.com/search/searchbox/v1/retrieve/$mapboxId?access_token=$mapboxToken&session_token=$_sessionToken";
      
      try {
        final response = await http.get(Uri.parse(detailUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final features = data['features'];
          
          if (features != null && features.isNotEmpty) {
            final properties = features[0]['properties'];
            if (properties != null) {
              final coordinates = properties['coordinates'];
              if (coordinates != null) {
                final lng = coordinates['longitude'];
                final lat = coordinates['latitude'];
                
                final h3 = await H3Helper.generateH3Index(lat, lng);

                setState(() {
                  if (isPickup) {
                    _selectedPickupLat = lat;
                    _selectedPickupLng = lng;
                    _selectedPickupH3 = h3;
                  } else {
                    _selectedDestinationLat = lat;
                    _selectedDestinationLng = lng;
                    _selectedDestinationH3 = h3;
                  }
                });
                
                if (_mapboxMap != null) {
                  await _mapboxMap?.flyTo(
                    CameraOptions(
                      center: Point(coordinates: Position(lng, lat)),
                      zoom: 16.0,
                    ),
                    MapAnimationOptions(duration: 800),
                  );
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error fetching details: $e");
      }
    }
  }

  // 2. PENCARIAN RUMAH SAKIT TUJUAN (Backend API) - Hanya untuk flow medis
  Future<void> searchDestinationHospitals(String query) async {
    if (query.isEmpty) {
      setState(() => _hospitalPredictions = []);
      return;
    }
    if (query.length < 2) return; 

    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "https://staging.resqlink.workers.dev";
    final String url = "$baseUrl/providers/search?q=${Uri.encodeComponent(query)}";
    
    final token = AuthHelper.token;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _hospitalPredictions = data;
        });
      } else {
        debugPrint("Gagal search providers: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("Error Search Providers: $e");
    }
  }

  // Method untuk memilih suggestion hospital
  Future<void> _selectHospitalSuggestion(Map<String, dynamic> hospital) async {

    final String name = hospital['name'] ?? 'Unknown Hospital';
    final double? lat = hospital['latitude'] as double?;
    final double? lng = hospital['longitude'] as double?;
    
    setState(() {
      _destinationController.text = name;
      _hospitalPredictions = [];
    });
    _destinationFocusNode.unfocus();
    
    if (lat != null && lng != null) {
      // Simpan koordinat destination
      _selectedDestinationLat = lat;
      _selectedDestinationLng = lng;
      
      // Generate H3 index untuk destination
      _selectedDestinationH3 = await H3Helper.generateH3Index(lat, lng);
      
      // Pindahkan kamera ke lokasi yang dipilih
      if (_mapboxMap != null) {
        _mapboxMap?.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(lng, lat)),
            zoom: 16.0,
          ),
          MapAnimationOptions(duration: 800),
        );
      }
    }
  }

  void _confirmAndPop() {
    final pickupData = LocationData(
      address: _pickupController.text,
      latitude: _selectedPickupLat ?? 0,
      longitude: _selectedPickupLng ?? 0,
      h3Index: _selectedPickupH3 ?? '',
    );
    
    final destinationData = LocationData(
      address: _destinationController.text,
      latitude: _selectedDestinationLat ?? 0,
      longitude: _selectedDestinationLng ?? 0,
      h3Index: _selectedDestinationH3 ?? '',
    );

    Navigator.pop(context, {
      'pickup': pickupData,
      'destination': destinationData,
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearchingPickup = _pickupFocusNode.hasFocus && _pickupController.text.isNotEmpty;
    final bool isSearchingDestination = _destinationFocusNode.hasFocus && _destinationController.text.isNotEmpty;
    final bool showSuggestionsPanel = isSearchingPickup || isSearchingDestination || _destinationFocusNode.hasFocus;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. FULL SCREEN MAPBOX VIEW
          Positioned.fill(
            bottom: showSuggestionsPanel ? 0 : 90,
            child: MapWidget(
              key: const ValueKey("fullMapboxWidget"),
              onMapCreated: _onMapCreated,
              styleUri: MapboxStyles.MAPBOX_STREETS,
              viewport: CameraViewportState(
                center: Point(coordinates: Position(106.816666, -6.200000)),
                zoom: 15.0,
              ),
            ),
          ),

          if (!showSuggestionsPanel)
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Icon(Icons.location_on_rounded, size: 42, color: Color(0xFF88B39F)),
              ),
            ),

          Positioned(
            top: 44,
            left: 16,
            child: SafeArea(
              top: false,
              child: GestureDetector(
                onTap: _confirmAndPop,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
                  ]),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
                ),
              ),
            ),
          ),

          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input Box Maps
                  Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                    ]),
                    child: LocationSelector(
                      pickupController: _pickupController,
                      destinationController: _destinationController,
                      pickupFocusNode: _pickupFocusNode,
                      destinationFocusNode: _destinationFocusNode,
                      onPickupChanged: (value) => searchPlaces(value, isPickup: true),
                      onDestinationChanged: (value) {
                        if (widget.destinationHint != null) {
                          searchPlaces(value, isPickup: false);
                        } else {
                          searchDestinationHospitals(value);
                        }
                      },
                      onCurrentLocationTap: _getCurrentLocation,
                      isGettingLocation: _isGettingLocation,
                      pickupHint: widget.pickupHint,
                      destinationHint: widget.destinationHint,
                    ),
                  ),

                  // PANEL BAWAH: MENAMPILKAN DATA DINAMIS
                  if (showSuggestionsPanel)
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6))],
                        ),
                        child: _buildDynamicPanelContent(isSearchingPickup, isSearchingDestination),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 5. TOMBOL KONFIRMASI DINAMIS
          if (!showSuggestionsPanel) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientButton(
                  title: _destinationController.text.isNotEmpty 
                      ? "Konfirmasi Tujuan" 
                      : "Konfirmasi Lokasi Jemput", 
                  onPressed: _confirmAndPop,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDynamicPanelContent(bool isSearchingPickup, bool isSearchingDestination) {
    // KONDISI A: Mengetik di Lokasi Jemput -> Rekomendasi Mapbox
    if (_pickupFocusNode.hasFocus) {
      if (_mapboxPredictions.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Ketik minimal 3 huruf untuk mencari penjemputan...", style: TextStyle(color: Colors.grey)),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _mapboxPredictions.length,
        itemBuilder: (context, index) {
          final item = _mapboxPredictions[index];
          final mainText = item['name'] ?? "";
          final secondaryText = item['full_address'] ?? item['place_formatted'] ?? "";
          return ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Color(0xFF097B45)),
            title: Text(
              mainText, 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              secondaryText, 
              style: const TextStyle(fontSize: 12, color: Colors.grey), 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _selectPlaceSuggestion(item, isPickup: true),
          );
        },
      );
    }

    // KONDISI B: Mengetik di Tujuan -> Hasil API Internal (Medis) ATAU Mapbox (Custom Hint flow)
    if (isSearchingDestination) {
      // B.1 Case: Custom Hint Flow (Generic Mapbox Search)
      if (widget.destinationHint != null) {
        if (_destinationMapboxPredictions.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Mencari lokasi tujuan...", style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _destinationMapboxPredictions.length,
          itemBuilder: (context, index) {
            final item = _destinationMapboxPredictions[index];
            final mainText = item['name'] ?? "";
            final secondaryText = item['full_address'] ?? item['place_formatted'] ?? "";
            return ListTile(
              leading: Icon(Icons.place_rounded, color: AppColors.primary),
              title: Text(
                mainText, 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                secondaryText, 
                style: const TextStyle(fontSize: 12, color: Colors.grey), 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _selectPlaceSuggestion(item, isPickup: false),
            );
          },
        );
      }

      // B.2 Case: Medical Flow (Internal Backend Search)
      if (_hospitalPredictions.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Tidak ada rumah sakit ditemukan", style: TextStyle(color: Colors.grey)),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _hospitalPredictions.length,
        itemBuilder: (context, index) {
          final hospital = _hospitalPredictions[index];
          final String name = hospital['name'] ?? 'Unknown Hospital';
          final String address = hospital['address'] ?? 'Indonesia';
          final String distance = hospital['distance'] != null ? ' (${hospital['distance']})' : '';
          
          return ListTile(
            leading: const Icon(Icons.local_hospital_rounded, color: Color(0xFFCC9E60)),
            title: Text(
              name, 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "$address$distance", 
              style: const TextStyle(fontSize: 12, color: Colors.grey), 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _selectHospitalSuggestion(hospital),
          );
        },
      );
    }

    // KONDISI C: Fokus di Tujuan tapi BELUM Mengetik -> Muncul Nearby Hospitals (hanya jika default flow)
    if (widget.destinationHint != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Silakan cari ${widget.destinationHint}...", 
          style: const TextStyle(color: Colors.grey)
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: NearestHospitalWidget(),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/common/gradient_button.dart';

class SelectDestinationScreen extends StatefulWidget {
  final String initialPickup;
  final String initialDestination;

  const SelectDestinationScreen({
    super.key,
    required this.initialPickup,
    required this.initialDestination,
  });

  @override
  State<SelectDestinationScreen> createState() => _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _pickupFocusNode = FocusNode();

  MapboxMap? _mapboxMap;
  List<dynamic> _predictions = [];

  // Tambahkan variabel ini untuk menampung session token Mapbox
  late String _sessionToken;

  @override
  void initState() {
    super.initState();
    _pickupController.text = widget.initialPickup;
    _destinationController.text = widget.initialDestination;

    // Generate token unik sederhana menggunakan timestamp milidetik saat screen dibuka
    _sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocusNode.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
  }

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    if (query.length < 3) return;

    final String mapboxToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    
    final String url =
        "https://api.mapbox.com/search/searchbox/v1/suggest?q=${Uri.encodeComponent(query)}&country=id&language=id&access_token=$mapboxToken&session_token=$_sessionToken";

    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _predictions = data['suggestions'] ?? [];
        });
      } else {
        debugPrint("Mapbox Search Gagal: ${response.statusCode} - ${response.body}");
        setState(() {
          _predictions = [];
        });
      }
    } catch (e) {
      debugPrint("Error Mapbox Search API: $e");
    }
  }

  void _confirmAndPop() {
    Navigator.pop(context, {
      'pickup': _pickupController.text,
      'destination': _destinationController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisplayingSuggestions = _predictions.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          
          Positioned.fill(
            bottom: isDisplayingSuggestions ? 0 : 90,
            child: MapWidget(
              key: const ValueKey("fullMapboxWidget"),
              onMapCreated: _onMapCreated,
              styleUri: MapboxStyles.MAPBOX_STREETS,
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(106.816666, -6.200000)), 
                zoom: 15.0,
              ),
            ),
          ),

          if (!isDisplayingSuggestions)
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 35), 
                child: Icon(
                  Icons.location_on_rounded,
                  size: 42,
                  color: Color(0xFF88B39F),
                ),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
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
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Kotak Input Alamat (Location Selector)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: LocationSelector(
                      pickupController: _pickupController,
                      destinationController: _destinationController,
                      pickupFocusNode: _pickupFocusNode,
                      onPickupChanged: (value) => searchPlaces(value),
                    ),
                  ),

                  if (isDisplayingSuggestions)
                    Flexible( 
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true, 
                          itemCount: _predictions.length,
                          itemBuilder: (context, index) {
                            final prediction = _predictions[index];
                            
                            final mainText = prediction['name'] ?? "";
                            final secondaryText = prediction['full_address'] ?? prediction['place_formatted'] ?? "";

                            return ListTile(
                              leading: const Icon(Icons.location_on_outlined, color: Color(0xFF88B39F)),
                              title: Text(
                                mainText,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                              ),
                              subtitle: Text(
                                secondaryText,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                // Masukkan alamat lengkap pilihan user ke teks input jemput
                                _pickupController.text = secondaryText.isNotEmpty ? "$mainText, $secondaryText" : mainText;
                                
                                setState(() {
                                  _predictions = []; // Tutup panel rekomendasi alamat
                                });
                                _pickupFocusNode.unfocus(); // Tutup keyboard
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 5. TOMBOL KONFIRMASI BAWAH
          if (!isDisplayingSuggestions) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientButton(
                  title: "Konfirmasi Lokasi Jemput",
                  onPressed: _confirmAndPop,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
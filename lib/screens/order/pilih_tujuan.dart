import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../widgets/order/location_selector.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/nearest_hospital.dart'; 
import '../../services/auth_helper.dart';

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
  final FocusNode _destinationFocusNode = FocusNode(); 

  MapboxMap? _mapboxMap;
  List<dynamic> _mapboxPredictions = []; 
  List<dynamic> _hospitalPredictions = []; 

  late String _sessionToken;

  @override
  void initState() {
    super.initState();
    _pickupController.text = widget.initialPickup;
    _destinationController.text = widget.initialDestination;
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

  // 1. PENCARIAN JEMPUT (Mapbox API) - FIXED TOKEN & RESET LOGIC
  Future<void> searchPickupPlaces(String query) async {
    if (query.isEmpty) {
      setState(() => _mapboxPredictions = []);
      return;
    }
    if (query.length < 3) return;

    // FIX: Mengembalikan pembacaan token ke dotenv agar sinkron dengan config inisialisasi awal
    final String mapboxToken = dotenv.env['MAPBOX_TOKEN'] ?? ""; 
    final String url =
        "https://api.mapbox.com/search/searchbox/v1/suggest?q=${Uri.encodeComponent(query)}&country=id&language=id&access_token=$mapboxToken&session_token=$_sessionToken";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _mapboxPredictions = data['suggestions'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error Mapbox: $e");
    }
  }

  // 2. PENCARIAN RUMAH SAKIT TUJUAN (Backend API) 
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

  void _confirmAndPop() {
    Navigator.pop(context, {
      'pickup': _pickupController.text,
      'destination': _destinationController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kondisi evaluasi penentu apakah panel suggest box bawah berhak muncul
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
              cameraOptions: CameraOptions(
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
                      onPickupChanged: (value) => searchPickupPlaces(value),
                      onDestinationChanged: (value) => searchDestinationHospitals(value),
                    ),
                  ),

                  // PANEL BAWAH: MENAMPILKAN DATA DINAMIS
                  if (showSuggestionsPanel)
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(4), // Dikecilkan agar list item tidak terlalu menjorok ke dalam
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

          // 5. TOMBOL KONFIRMASI DINAMIS (Disesuaikan dengan isi field)
          if (!showSuggestionsPanel) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientButton(
                  // Jika field tujuan sudah diisi, ganti text tombolnya menjadi Konfirmasi Tujuan
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
            leading: const Icon(Icons.location_on_outlined, color: Color(0xFF88B39F)),
            title: Text(mainText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(secondaryText, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              _pickupController.text = secondaryText.isNotEmpty ? "$mainText, $secondaryText" : mainText;
              setState(() => _mapboxPredictions = []);
              _pickupFocusNode.unfocus();
            },
          );
        },
      );
    }

    // KONDISI B: Mengetik di RS Tujuan -> Hasil API Internal /providers/search
    if (isSearchingDestination) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _hospitalPredictions.length,
        itemBuilder: (context, index) {
          final hospital = _hospitalPredictions[index];
          final String name = hospital['name'] ?? 'Unknown Hospital';
          final String address = hospital['address'] ?? 'Indonesia';
          
          return ListTile(
            leading: const Icon(Icons.local_hospital_rounded, color: Color(0xFFCC9E60)),
            title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(address, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              _destinationController.text = name;
              setState(() => _hospitalPredictions = []);
              _destinationFocusNode.unfocus();
            },
          );
        },
      );
    }

    // KONDISI C: Fokus di RS Tujuan tapi BELUM Mengetik -> Muncul Nearby Hospitals!
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: NearestHospitalWidget(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../themes/app_colors.dart';
import '../../services/auth_helper.dart';
import '../tracking/tracking_screen.dart';
import '../history/history_detail_screen.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final String? jwtToken = AuthHelper.token;
      if (jwtToken == null) {
        throw Exception('Token tidak ditemukan');
      }

      final String baseUrl = dotenv.env['API_BASE_URL'] ?? "http://localhost:3000";
      final url = Uri.parse("$baseUrl/bookings");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _bookings = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: AppBar(
        title: const Text(
          "Aktivitas",
          style: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.darkBrown),
            onPressed: _fetchBookings,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/medic_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Content
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _error != null
                  ? _buildErrorState()
                  : _bookings.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          itemCount: _bookings.length,
                          itemBuilder: (context, index) {
                            final booking = _bookings[index];
                            return _buildActivityCard(context, booking);
                          },
                        ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.textGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: AppColors.textGrey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada aktivitas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pemesanan ambulance Anda akan muncul di sini',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, dynamic booking) {
    // Ambil data dari API langsung
    final String bookingId = booking['id'] ?? '';
    final String bookingType = booking['booking_type'] ?? 'Unknown';
    final String createdAt = booking['created_at'] ?? 'Tanggal tidak tersedia';
    final String status = booking['status'] ?? 'unknown';
    final int totalPrice = booking['estimated_price'] ?? 0;
    
    // Tentukan display name untuk tipe
    String displayType = 'Ambulans';
    if (bookingType.toLowerCase() == 'medis') {
      displayType = 'Ambulans Medis';
    } else if (bookingType.toLowerCase() == 'sosial') {
      displayType = 'Ambulans Sosial';
    } else if (bookingType.toLowerCase() == 'jenazah') {
      displayType = 'Ambulans Jenazah';
    }
    
    // Tentukan icon berdasarkan tipe
    String iconAsset = 'assets/images/ambulance_medis.svg';
    if (bookingType.toLowerCase() == 'sosial') {
      iconAsset = 'assets/images/ambulance_sosial.svg';
    } else if (bookingType.toLowerCase() == 'jenazah') {
      iconAsset = 'assets/images/ambulance_jenazah.svg';
    }
    
    // Tentukan status display dan warna
    Color statusColor = Colors.grey;
    String statusText = status;
    final bool isCompleted = (status == 'completed');
    
    if (status == 'completed') {
      statusColor = Colors.green;
      statusText = 'Selesai';
    } else if (status == 'cancelled') {
      statusColor = Colors.red;
      statusText = 'Dibatalkan';
    } else if (status == 'draft') {
      statusColor = Colors.orange;
      statusText = 'Menunggu';
    } else if (status == 'confirmed') {
      statusColor = Colors.blue;
      statusText = 'Dikonfirmasi';
    } else if (status == 'en_route') {
      statusColor = Colors.blue;
      statusText = 'Menuju Lokasi Jemput';
    } else if (status == 'arrived') {
      statusColor = Colors.green;
      statusText = 'Tiba di Lokasi Jemput';
    } else if (status == 'to_hospital') {
      statusColor = Colors.purple;
      statusText = 'Menuju RS';
    }
    
    // Format harga
    String priceText = 'Rp0';
    if (totalPrice > 0) {
      priceText = 'Rp${totalPrice.toString()}';
    } else if (bookingType.toLowerCase() == 'sosial') {
      priceText = 'Rp0 (Gratis)';
    }

    String formattedDate = 'Tanggal tidak tersedia';
    if (createdAt.isNotEmpty) {
      try {
        // Parse string ke DateTime (asumsi dari API dalam UTC)
        final DateTime utcDateTime = DateTime.parse(createdAt);
        
        // Konversi ke GMT+7 (tambah 7 jam)
        final DateTime localDateTime = utcDateTime.add(const Duration(hours: 7));
        
        // Array nama bulan bahasa Indonesia
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
          'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
        ];
        
        final day = localDateTime.day;
        final month = months[localDateTime.month - 1];
        final year = localDateTime.year;
        final hour = localDateTime.hour.toString().padLeft(2, '0');
        final minute = localDateTime.minute.toString().padLeft(2, '0');
        
        formattedDate = '$day $month $year, $hour:$minute';
      } catch (e) {
        formattedDate = createdAt;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          if (isCompleted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryDetailScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackingScreen(
                  bookingId: bookingId,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SvgPicture.asset(
                      iconAsset,
                      semanticsLabel: displayType,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              displayType,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Lihat Detail",
                    style: TextStyle(
                      color: AppColors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../schema/location.dart';
import '../../schema/provider.dart';
import '../../widgets/common/gradient_button.dart';
import 'order_success_screen.dart';

class WelcabConfirmationScreen extends StatelessWidget {
  final Provider selectedProvider;
  final LocationData pickupLocation;
  final LocationData destinationLocation;
  
  // Welcab Specifics
  final String wheelchairType;
  final int passengerCount;
  final bool needAssistance;
  final bool needMedicalTools;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String notes;

  const WelcabConfirmationScreen({
    super.key,
    required this.selectedProvider,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.wheelchairType,
    required this.passengerCount,
    required this.needAssistance,
    required this.needMedicalTools,
    required this.selectedDate,
    required this.selectedTime,
    this.notes = "",
  });

  String get _formattedDate => "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}";
  String get _formattedTime => "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  void _onConfirm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          providerName: selectedProvider.name,
          serviceType: "Layanan Welcab",
          bookingDate: "$_formattedDate, $_formattedTime",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Konfirmasi Pesanan', style: AppTypography.h3),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header
              _buildSectionTitle('Detail Perjalanan'),
              const SizedBox(height: 16),
              _buildLocationCard(),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle('Layanan Welcab'),
              const SizedBox(height: 16),
              _buildDetailCard(),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle('Informasi Provider'),
              const SizedBox(height: 16),
              _buildProviderCard(),
              
              const SizedBox(height: 32),
              
              _buildPriceSection(),
              
              const SizedBox(height: 40),
              
              GradientButton(
                title: "Konfirmasi & Cari Armada",
                onPressed: () => _onConfirm(context),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batalkan",
                    style: AppTypography.button.copyWith(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.title.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          _buildLocationItem(
            icon: Icons.my_location,
            color: AppColors.primary,
            label: 'Penjemputan',
            address: pickupLocation.address,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(width: 2, height: 20, color: AppColors.divider),
            ),
          ),
          _buildLocationItem(
            icon: Icons.location_on,
            color: Colors.red,
            label: 'Tujuan',
            address: destinationLocation.address,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem({required IconData icon, required Color color, required String label, required String address}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.captionSmall.copyWith(color: AppColors.textGrey)),
              const SizedBox(height: 2),
              Text(
                address,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.wheelchair_pickup, 'Tipe Kursi Roda', wheelchairType),
          const Divider(height: 24),
          _buildInfoRow(Icons.people_outline, 'Jumlah Pendamping', '$passengerCount Orang'),
          const Divider(height: 24),
          _buildInfoRow(Icons.medical_services_outlined, 'Pendamping Medis', needAssistance ? 'Ya' : 'Tidak'),
          const Divider(height: 24),
          _buildInfoRow(Icons.calendar_today_outlined, 'Jadwal Penjemputan', '$_formattedDate, $_formattedTime'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(label, style: AppTypography.body.copyWith(color: AppColors.textGrey, fontSize: 14)),
        const Spacer(),
        Text(value, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildProviderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.airport_shuttle, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedProvider.name, style: AppTypography.title.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(selectedProvider.providerType, style: AppTypography.captionSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Estimasi', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
          Text(
            'Rp 350.000', 
            style: AppTypography.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

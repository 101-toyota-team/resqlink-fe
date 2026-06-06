import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/order_map_preview.dart';
import '../../schema/location.dart';
import 'welcab_confirmation_screen.dart';
import '../../schema/provider.dart';

class WelcabBookingScreen extends StatefulWidget {
  const WelcabBookingScreen({super.key});

  @override
  State<WelcabBookingScreen> createState() => _WelcabBookingScreenState();
}

class _WelcabBookingScreenState extends State<WelcabBookingScreen> {
  // Location Data
  LocationData _pickupLocation = LocationData(address: "", latitude: 0.0, longitude: 0.0, h3Index: "");
  LocationData _destinationLocation = LocationData(address: "", latitude: 0.0, longitude: 0.0, h3Index: "");

  // Form State
  String _wheelchairType = "Manual";
  int _passengerCount = 1;
  bool _needAssistance = false;
  bool _rentWheelchair = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _proceed() {
    if (_pickupLocation.address.isEmpty || _destinationLocation.address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih lokasi jemput dan tujuan')),
      );
      return;
    }

    // Dummy Welcab Provider (Internal ResQLink)
    final welcabProvider = Provider(
      id: 'resqlink_welcab_internal',
      name: 'ResQLink Welcab Official',
      providerType: 'Layanan Internal',
      address: 'Pusat Operasional ResQLink',
      city: 'Jakarta',
      phone: '081122334455',
      latitude: _pickupLocation.latitude,
      longitude: _pickupLocation.longitude,
      h3Index: _pickupLocation.h3Index,
      isActive: true,
      createdAt: DateTime.now(),
      distance: 'Terdekat',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcabConfirmationScreen(
          selectedProvider: welcabProvider,
          pickupLocation: _pickupLocation,
          destinationLocation: _destinationLocation,
          wheelchairType: _wheelchairType,
          passengerCount: _passengerCount,
          needAssistance: _needAssistance,
          needMedicalTools: _rentWheelchair,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          notes: _notesController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/resqlink-banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient Overlay for text visibility
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
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
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pesan Mobil Welcab',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.white,
                          fontSize: 28,
                          shadows: [
                            const Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Transportasi ramah disabilitas & lansia',
                        style: AppTypography.bodyWhite.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          shadows: [
                            const Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Map Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: OrderMapPreview(
                        pickupHint: 'Lokasi Penjemputan',
                        destinationHint: 'Lokasi Tujuan (RS/Klinik/Lainnya)',
                        onLocationChanged: (pickup, dest) {
                          setState(() {
                            _pickupLocation = pickup;
                            _destinationLocation = dest;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Configuration Card
                    _buildFormCard(
                      title: 'Detail Kebutuhan',
                      icon: Icons.settings_accessibility_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Tipe Kursi Roda'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildChoiceChip('Manual'),
                              const SizedBox(width: 10),
                              _buildChoiceChip('Elektrik'),
                              const SizedBox(width: 10),
                              _buildChoiceChip('Sedia dari Kami'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Jumlah Pendamping'),
                                  Text('Maksimal 3 orang', style: AppTypography.captionSmall),
                                ],
                              ),
                              _buildCounter(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional Services Card
                    _buildFormCard(
                      title: 'Layanan Tambahan',
                      icon: Icons.medical_services_rounded,
                      child: Column(
                        children: [
                          SwitchListTile(
                            value: _needAssistance,
                            onChanged: (val) => setState(() => _needAssistance = val),
                            title: Text('Pendamping Medis', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: Text('Bantuan perawat profesional selama perjalanan', style: AppTypography.captionSmall),
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Divider(color: AppColors.divider),
                          SwitchListTile(
                            value: _rentWheelchair,
                            onChanged: (val) => setState(() => _rentWheelchair = val),
                            title: Text('Oksigen & Alat Medis', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: Text('Penyediaan oksigen portable dan alat monitoring', style: AppTypography.captionSmall),
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Schedule Card
                    _buildFormCard(
                      title: 'Jadwal Penjemputan',
                      icon: Icons.calendar_today_rounded,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildPickerTile(
                              label: 'Tanggal',
                              value: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                              icon: Icons.event,
                              onTap: () => _selectDate(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPickerTile(
                              label: 'Waktu',
                              value: _selectedTime.format(context),
                              icon: Icons.access_time,
                              onTap: () => _selectTime(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: GradientButton(
                        title: "Cari Mobil Welcab",
                        onPressed: _proceed,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.title.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textGrey),
    );
  }

  Widget _buildChoiceChip(String label) {
    final isSelected = _wheelchairType == label;
    return GestureDetector(
      onTap: () => setState(() => _wheelchairType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(
          label,
          style: AppTypography.captionSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _counterAction(Icons.remove, () {
            if (_passengerCount > 0) setState(() => _passengerCount--);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('$_passengerCount', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
          ),
          _counterAction(Icons.add, () {
            if (_passengerCount < 3) setState(() => _passengerCount++);
          }),
        ],
      ),
    );
  }

  Widget _counterAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  Widget _buildPickerTile({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(value, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

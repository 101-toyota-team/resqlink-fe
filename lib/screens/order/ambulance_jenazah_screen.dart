import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/order/order_map_preview.dart';
import '../../schema/location.dart';
import 'ambulance_selection_screen.dart';

class AmbulanceJenazahScreen extends StatefulWidget {
  const AmbulanceJenazahScreen({super.key});

  @override
  State<AmbulanceJenazahScreen> createState() => _AmbulanceJenazahScreenState();
}

class _AmbulanceJenazahScreenState extends State<AmbulanceJenazahScreen> {
  // Location Data
  LocationData _pickupLocation = LocationData(address: "", latitude: 0.0, longitude: 0.0, h3Index: "");
  LocationData _destinationLocation = LocationData(address: "", latitude: 0.0, longitude: 0.0, h3Index: "");

  // Form Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _proceed() {
    if (_pickupLocation.address.isEmpty || _destinationLocation.address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih lokasi jemput dan tujuan')),
      );
      return;
    }
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan isi nama almarhum/ah')),
      );
      return;
    }

    // Dummy navigation to selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmbulanceSelectionScreen(
          pickupLocation: _pickupLocation,
          destinationLocation: _destinationLocation,
          patientCondition: "Layanan Jenazah: ${_nameController.text}, Tanggal: ${_selectedDate.day}/${_selectedDate.month}, Jam: ${_selectedTime.format(context)}",
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
                  height: 220,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/resqlink-banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.6)],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ambulan Jenazah',
                        style: AppTypography.h2.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Layanan pengantaran jenazah yang layak dan aman',
                        style: AppTypography.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
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
                    // Map & Location Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: OrderMapPreview(
                        pickupHint: 'Cari Lokasi Penjemputan Jenazah',
                        destinationHint: 'Cari Lokasi Pemakaman / Rumah Duka',
                        onLocationChanged: (pickup, dest) {
                          setState(() {
                            _pickupLocation = pickup;
                            _destinationLocation = dest;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Deceased Info Card
                    _buildFormCard(
                      title: 'Data Almarhum/ah',
                      icon: Icons.person_outline_rounded,
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama almarhum/ah',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Usia (Opsional)',
                            hint: 'Contoh: 70 Tahun',
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Schedule Card
                    _buildFormCard(
                      title: 'Jadwal Keberangkatan',
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
                    const SizedBox(height: 16),

                    // Service Type Card
                    _buildFormCard(
                      title: 'Tipe Layanan',
                      icon: Icons.category_rounded,
                      child: Row(
                        children: [
                          _buildChipSelection("Dalam Kota", true),
                          const SizedBox(width: 12),
                          _buildChipSelection("Luar Kota", false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: GradientButton(
                        title: "Lanjut ke Pilih Armada",
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

  Widget _buildChipSelection(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : AppColors.textGrey,
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textGrey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.caption.copyWith(color: AppColors.textGrey.withValues(alpha: 0.5)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickerTile({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textGrey),
          ),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class AmbulanceDetailBottomSheet extends StatefulWidget {
  final String name;
  final String distance;
  final String duration;
  final String price;
  final String treatment;
  final String phoneNumber;
  final String providerType;
  final String address;
  final VoidCallback? onSelect;

  const AmbulanceDetailBottomSheet({
    super.key,
    required this.name,
    required this.distance,
    required this.duration,
    required this.price,
    required this.treatment,
    this.phoneNumber = '',
    this.providerType = 'Rumah Sakit',
    this.address = '',
    this.onSelect,
  });

  @override
  State<AmbulanceDetailBottomSheet> createState() => _AmbulanceDetailBottomSheetState();
}

class _AmbulanceDetailBottomSheetState extends State<AmbulanceDetailBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  int _currentImageIndex = 0;
  late List<String> imagePaths;

  @override
  void initState() {
    super.initState();
    imagePaths = [
      'assets/images/ambulance_detail_1.jpg',
      'assets/images/ambulance_detail_2.jpg',
      'assets/images/ambulance_detail_3.jpg',
      'assets/images/ambulance_detail_4.jpg',
      'assets/images/ambulance_detail_5.png',
      'assets/images/ambulance_detail_6.png',
      'assets/images/ambulance_detail_7.png',
    ];
    
    _scrollController.addListener(_updateScrollIndicator);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollIndicator);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicator() {
    if (!_scrollController.hasClients) return;
    
    final currentScroll = _scrollController.position.pixels;
    final itemWidth = 180.0 + 12.0; // width + margin right
    
    final newIndex = (currentScroll / itemWidth).round();
    
    if (newIndex != _currentImageIndex && newIndex < imagePaths.length) {
      setState(() {
        _currentImageIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar and close button
          Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textGrey),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          
          // Make content scrollable
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Provider name and type
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.truckMedical,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: AppTypography.h3.copyWith(height: 1.2),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.providerType,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Image Gallery Section with scroll indicator
                  _buildImageGallery(),
                  
                  const SizedBox(height: 24),
                  
                  // Info cards (distance, duration, price)
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.location_on_rounded,
                          label: 'Jarak',
                          value: widget.distance,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.access_time_filled_rounded,
                          label: 'Estimasi',
                          value: widget.duration,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.payments_rounded,
                          label: 'Harga',
                          value: widget.price,
                          isPrice: true,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Treatment info
                  _buildDetailItem(
                    icon: FontAwesomeIcons.briefcaseMedical,
                    label: 'Layanan & Fasilitas',
                    value: widget.treatment,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Address if available
                  if (widget.address.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.location_on_outlined,
                      label: 'Alamat Lokasi',
                      value: widget.address,
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Phone number if available
                  if (widget.phoneNumber.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.phone_rounded,
                      label: 'Nomor Telepon',
                      value: widget.phoneNumber,
                    ),
                  
                  const SizedBox(height: 32),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text('Batal', style: AppTypography.button.copyWith(color: AppColors.primary)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onSelect?.call();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text('Pilih Ambulan Ini', style: AppTypography.button),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
              icon,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Foto Armada',
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w800),
            ),
            // Indikator "Geser ke samping"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.swipe_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Geser ke samping',
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ListView horizontal
        SizedBox(
          height: 130,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePaths[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.cardBg,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              size: 40,
                              color: AppColors.textGrey.withOpacity(0.3),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Foto ${index + 1}',
                              style: AppTypography.captionSmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // ✅ Scroll indicator dots (dinamis, berubah saat scroll)
        _buildScrollIndicator(),
      ],
    );
  }

  // Widget untuk indikator dot yang berubah sesuai posisi scroll
  Widget _buildScrollIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        imagePaths.length,
        (index) => GestureDetector(
          onTap: () {
            // Scroll ke foto yang dipilih saat dot diklik
            final itemWidth = 180.0 + 12.0; // width + margin right
            _scrollController.animateTo(
              index * itemWidth,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentImageIndex == index ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: _currentImageIndex == index 
                  ? AppColors.primary 
                  : AppColors.textGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isPrice;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTypography.captionSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontSize: isPrice ? 12 : 14,
              fontWeight: FontWeight.w800,
              color: isPrice ? AppColors.primary : AppColors.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
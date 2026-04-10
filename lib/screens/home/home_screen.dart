import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_colors.dart';
import '../../widgets/common/rq_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ResQLink',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.bgLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Emergency Ambulance Services',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Get immediate medical assistance when you need it most. Our network of professional ambulance services is ready to respond 24/7.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Book Ambulance Button
            RqButton(
              label: 'Book Ambulance Now',
              icon: Icons.local_hospital,
              onPressed: () {
                // TODO: Navigate to booking screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking feature coming soon!'),
                    backgroundColor: AppColors.accent,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Disease Selection Section
            Text(
              'Select Emergency Type',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Disease Selection Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgLighter,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryLighter,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryLighter,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search emergency type...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Emergency Type Grid
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildEmergencyTypeCard(
                        icon: Icons.favorite,
                        label: 'Heart Attack',
                        color: Colors.red,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.psychology,
                        label: 'Stroke',
                        color: Colors.purple,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.directions_car,
                        label: 'Accident',
                        color: Colors.orange,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.air,
                        label: 'Respiratory',
                        color: Colors.blue,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.warning,
                        label: 'Severe Pain',
                        color: Colors.amber,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.visibility_off,
                        label: 'Unconscious',
                        color: Colors.grey,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.science,
                        label: 'Poisoning',
                        color: Colors.green,
                      ),
                      _buildEmergencyTypeCard(
                        icon: Icons.local_fire_department,
                        label: 'Burns',
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Features Section
            Text(
              'Why Choose ResQLink?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Feature Cards
            _buildFeatureCard(
              icon: Icons.speed,
              title: 'Fast Response',
              description: 'Average response time under 10 minutes in urban areas.',
            ),
            const SizedBox(height: 12),

            _buildFeatureCard(
              icon: Icons.verified,
              title: 'Certified Professionals',
              description: 'All our ambulance crews are fully trained and certified.',
            ),
            const SizedBox(height: 12),

            _buildFeatureCard(
              icon: Icons.location_on,
              title: 'GPS Tracking',
              description: 'Real-time tracking of ambulance location and ETA.',
            ),
            const SizedBox(height: 12),

            _buildFeatureCard(
              icon: Icons.support,
              title: '24/7 Support',
              description: 'Round-the-clock customer support for all your needs.',
            ),

            const SizedBox(height: 40),

            // Footer
            Center(
              child: Text(
                'ResQLink - Saving Lives, One Ride at a Time',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTypeCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to booking with selected emergency type
        // For now, show a snackbar
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLighter,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryLighter,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
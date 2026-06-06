import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../themes/app_colors.dart';
import '../themes/app_typography.dart';
import 'login/login_screen.dart';
import 'register/register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _goLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _goRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.cardBg,
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
                child: Column(
                  children: [
                    // Logo Section
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/ResQLink_Logo.png',
                        height: 60, 
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const Spacer(flex: 2),

                    // Illustration & Content Section
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/emergency.svg',
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          'Welcome to ResQLink!',
                          textAlign: TextAlign.center,
                          style: AppTypography.h1.copyWith(
                            fontSize: 30,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Akses layanan ambulans darurat dengan lebih cepat, jelas, dan tenang.',
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              fontSize: 15,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 3),

                    // Button Section
                    Column(
                      children: [
                        _buildButton(
                          label: 'Buat Akun Baru',
                          onPressed: () => _goRegister(context),
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 14),
                        _buildButton(
                          label: 'Masuk ke Akun',
                          onPressed: () => _goLogin(context),
                          backgroundColor: Colors.white,
                          textColor: AppColors.primary,
                          isOutlined: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Footer Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Dengan melanjutkan, Anda menyetujui Syarat Layanan dan Kebijakan Privasi kami.',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: isOutlined ? 0 : 4,
          shadowColor: isOutlined ? Colors.transparent : AppColors.primary.withOpacity(0.3),
          side: isOutlined ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.button.copyWith(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        backgroundColor: const Color(0xFFFFF9E9),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/images/ResQLink_Logo.png',
                    height: 70, 
                    fit: BoxFit.contain,
                  ),
                ),
                
                const Spacer(flex: 1),

                // CONTENT TENGAH
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/emergency.svg',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Welcome to ResQLink!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Akses ambulans dengan lebih cepat, jelas, dan tenang.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // BUTTON SECTION
                Column(
                  children: [
                    _buildButton(
                      label: 'Buat akun',
                      onPressed: () => _goRegister(context),
                      backgroundColor: const Color(0xFF9E1411),
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    _buildButton(
                      label: 'Masuk',
                      onPressed: () => _goLogin(context),
                      backgroundColor: Colors.white,
                      textColor: const Color(0xFF9E1411),
                      isOutlined: true,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // FOOTER
                Text(
                  'Dengan melanjutkan, Anda menyetujui\nSyarat Layanan dan Kebijakan Privasi',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF999999),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
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
          elevation: 0,
          side: isOutlined ? BorderSide(color: textColor, width: 1.5) : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
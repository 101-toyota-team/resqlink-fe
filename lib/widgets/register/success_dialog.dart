import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

/// Success dialog for registration completion
class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.onDone,
    this.title = 'Pendaftaran berhasil!',
    this.message =
        'Akun provider Anda sedang dalam proses verifikasi. Tim kami akan menghubungi dalam 1×24 jam.',
    this.buttonLabel = 'Kembali ke beranda',
  });

  final VoidCallback onDone;
  final String title;
  final String message;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      backgroundColor: C.bgSheet,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckIcon(),
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildMessage(),
            const SizedBox(height: 24),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckIcon() => Container(
    width: 72,
    height: 72,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [C.teal700, C.teal500],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.check_rounded,
      color: Colors.white,
      size: 36,
    ),
  );

  Widget _buildTitle() => Text(
    title,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: C.ink,
      letterSpacing: -0.5,
    ),
  );

  Widget _buildMessage() => Text(
    message,
    textAlign: TextAlign.center,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 13.5,
      color: C.ink2,
      height: 1.55,
      letterSpacing: -0.1,
    ),
  );

  Widget _buildButton() => SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: onDone,
      style: ElevatedButton.styleFrom(
        backgroundColor: C.teal700,
        foregroundColor: C.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    ),
  );
}

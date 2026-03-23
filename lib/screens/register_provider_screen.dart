import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_theme.dart';
import '../themes/app_widgets.dart';

class RegisterProviderScreen extends StatefulWidget {
  const RegisterProviderScreen({super.key});
  @override
  State<RegisterProviderScreen> createState() =>
      _RegisterProviderScreenState();
}

class _RegisterProviderScreenState extends State<RegisterProviderScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addrCtrl  = TextEditingController();
  final _licCtrl   = TextEditingController();
  final _adminUCtrl = TextEditingController();
  final _adminPCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  int  _step    = 0;

  FieldState _nameState  = FieldState.idle;
  FieldState _emailState = FieldState.idle;
  FieldState _phoneState = FieldState.idle;
  FieldState _addrState  = FieldState.idle;
  FieldState _licState   = FieldState.idle;
  FieldState _auState    = FieldState.idle;
  FieldState _apState    = FieldState.idle;

  String? _eErr, _pErr;

  @override
  void initState() {
    super.initState();
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl,
        _addrCtrl, _licCtrl, _adminUCtrl, _adminPCtrl]) {
      c.addListener(_validate);
    }
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl,
        _addrCtrl, _licCtrl, _adminUCtrl, _adminPCtrl]) c.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _nameState  = _nameCtrl.text.trim().isNotEmpty  ? FieldState.filled : FieldState.idle;
      _phoneState = _phoneCtrl.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;
      _addrState  = _addrCtrl.text.trim().isNotEmpty  ? FieldState.filled : FieldState.idle;
      _licState   = _licCtrl.text.trim().isNotEmpty   ? FieldState.filled : FieldState.idle;
      _auState    = _adminUCtrl.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;

      final e = _emailCtrl.text.trim();
      if (e.isEmpty) { _emailState = FieldState.idle; _eErr = null; }
      else if (!e.contains('@') || !e.contains('.')) {
        _emailState = FieldState.error; _eErr = 'Format email tidak valid';
      } else { _emailState = FieldState.filled; _eErr = null; }

      final p = _adminPCtrl.text;
      if (p.isEmpty) { _apState = FieldState.idle; _pErr = null; }
      else if (p.length < 6) { _apState = FieldState.error; _pErr = 'Minimal 6 karakter'; }
      else { _apState = FieldState.filled; _pErr = null; }
    });
  }

  void _next() {
    if (_step == 0) {
      if (_nameState != FieldState.filled ||
          _emailState != FieldState.filled ||
          _phoneState != FieldState.filled) {
        setState(() {
          if (_nameCtrl.text.trim().isEmpty) _nameState = FieldState.error;
          if (_emailCtrl.text.trim().isEmpty) _emailState = FieldState.error;
          if (_phoneCtrl.text.trim().isEmpty) _phoneState = FieldState.error;
        });
        return;
      }
      setState(() => _step = 1);
    } else {
      _submit();
    }
  }

  void _submit() async {
    if (_auState != FieldState.filled || _apState != FieldState.filled) {
      setState(() {
        if (_adminUCtrl.text.trim().isEmpty) _auState = FieldState.error;
        if (_adminPCtrl.text.isEmpty) _apState = FieldState.error;
      });
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        onDone: () => Navigator.of(context).popUntil((r) => r.isFirst),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeroShell(
      title: _step == 0
          ? 'Daftarkan\ninstitusi Anda'
          : 'Buat akun\nadmin utama',
      subtitle: _step == 0
          ? 'Langkah 1 dari 2 — Data perusahaan'
          : 'Langkah 2 dari 2 — Kelola platform Anda',
      heroFrac: 0.36,
      back: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step bar
          StepBar(
            current: _step,
            labels: const ['Data institusi', 'Akun admin'],
          ),
          const SizedBox(height: 24),

          if (_step == 0) ...[
            RqTextField(
              label: 'NAMA INSTITUSI',
              controller: _nameCtrl,
              hint: 'RS Pondok Indah, PMI Jakarta...',
              state: _nameState,
              error: 'Nama institusi wajib diisi',
              suffix: Icons.business_rounded,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            RqTextField(
              label: 'EMAIL RESMI',
              controller: _emailCtrl,
              hint: 'admin@institusi.co.id',
              state: _emailState,
              error: _eErr,
              suffix: _emailState == FieldState.error
                  ? Icons.info_outline_rounded
                  : Icons.mail_outline_rounded,
              keyboard: TextInputType.emailAddress,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            RqTextField(
              label: 'NOMOR TELEPON',
              controller: _phoneCtrl,
              hint: '+62 21 xxxx xxxx',
              state: _phoneState,
              error: 'Nomor telepon wajib diisi',
              suffix: Icons.phone_outlined,
              keyboard: TextInputType.phone,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            RqTextField(
              label: 'ALAMAT (OPSIONAL)',
              controller: _addrCtrl,
              hint: 'Jl. Sudirman No. 1...',
              state: _addrState,
              suffix: Icons.location_on_outlined,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            RqTextField(
              label: 'NO. IZIN OPERASIONAL (OPSIONAL)',
              controller: _licCtrl,
              hint: 'No. izin ambulans',
              state: _licState,
              suffix: Icons.badge_outlined,
              action: TextInputAction.done,
            ),
          ],

          if (_step == 1) ...[
            // Info card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5F6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: C.teal100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: C.teal500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined,
                        color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Akun ini adalah admin utama. Setelah masuk, Anda bisa menambahkan driver, dispatcher, dan admin tambahan.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: C.teal700,
                        height: 1.55,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            RqTextField(
              label: 'USERNAME ADMIN',
              controller: _adminUCtrl,
              hint: 'Pilih username unik',
              state: _auState,
              error: 'Username wajib diisi',
              suffix: Icons.manage_accounts_outlined,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            RqTextField(
              label: 'PASSWORD',
              controller: _adminPCtrl,
              hint: 'Minimal 6 karakter',
              obscure: _obscure,
              state: _apState,
              error: _pErr,
              suffix: _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixTap: () => setState(() => _obscure = !_obscure),
              action: TextInputAction.done,
              onSubmit: (_) => _submit(),
            ),
            if (_adminPCtrl.text.isNotEmpty)
              PasswordStrengthBar(password: _adminPCtrl.text),
          ],

          const SizedBox(height: 24),

          RqButton(
            label: _step == 0 ? 'Lanjutkan' : 'Daftarkan provider',
            icon: _step == 0
                ? Icons.arrow_forward_rounded
                : Icons.check_rounded,
            loading: _loading,
            onPressed: _next,
          ),

          if (_step == 1) ...[
            const SizedBox(height: 14),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _step = 0),
                child: Text('Kembali ke data institusi',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: C.teal500)),
              ),
            ),
          ],

          const SizedBox(height: 20),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: C.ink3, height: 1.6),
                children: [
                  const TextSpan(text: 'Dengan mendaftar Anda menyetujui '),
                  TextSpan(
                      text: 'Syarat Layanan',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: C.teal500,
                          fontWeight: FontWeight.w600)),
                  const TextSpan(text: ' dan '),
                  TextSpan(
                      text: 'Kebijakan Privasi',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: C.teal500,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success dialog ─────────────────────────────────────────────────────────────
class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: C.bgSheet,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check icon
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [C.teal700, C.teal500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            Text('Pendaftaran berhasil!',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 20, fontWeight: FontWeight.w800,
                    color: C.ink, letterSpacing: -0.5)),
            const SizedBox(height: 8),
            Text(
              'Akun provider Anda sedang dalam proses verifikasi. Tim kami akan menghubungi dalam 1×24 jam.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5, color: C.ink2,
                  height: 1.55, letterSpacing: -0.1),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.teal700,
                  foregroundColor: C.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Kembali ke beranda',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        letterSpacing: -0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

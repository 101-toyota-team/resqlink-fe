import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../themes/app_theme.dart';
import '../themes/app_widgets.dart';

final AuthService _authService = AuthService();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _uCtrl  = TextEditingController();
  final _eCtrl  = TextEditingController();
  final _fnCtrl = TextEditingController();
  final _lnCtrl = TextEditingController();
  final _pCtrl  = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  FieldState _uState  = FieldState.idle;
  FieldState _eState  = FieldState.idle;
  FieldState _fnState = FieldState.idle;
  FieldState _lnState = FieldState.idle;
  FieldState _pState  = FieldState.idle;

  String? _eErr, _pErr;

  @override
  void initState() {
    super.initState();
    for (final c in [_uCtrl, _eCtrl, _fnCtrl, _lnCtrl, _pCtrl]) {
      c.addListener(_validate);
    }
  }

  @override
  void dispose() {
    for (final c in [_uCtrl, _eCtrl, _fnCtrl, _lnCtrl, _pCtrl]) c.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _uState = _uCtrl.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;

      final e = _eCtrl.text.trim();
      if (e.isEmpty) { _eState = FieldState.idle; _eErr = null; }
      else if (!e.contains('@') || !e.contains('.')) {
        _eState = FieldState.error; _eErr = 'Format email tidak valid';
      } else { _eState = FieldState.filled; _eErr = null; }

      _fnState = _fnCtrl.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;
      _lnState = _lnCtrl.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;

      final p = _pCtrl.text;
      if (p.isEmpty) { _pState = FieldState.idle; _pErr = null; }
      else if (p.length < 6) { _pState = FieldState.error; _pErr = 'Minimal 6 karakter'; }
      else { _pState = FieldState.filled; _pErr = null; }
    });
  }

  void _submit() async {
    if (_uCtrl.text.trim().isEmpty || _eState != FieldState.filled ||
        _pState != FieldState.filled) {
      setState(() {
        if (_uCtrl.text.trim().isEmpty) _uState = FieldState.error;
        if (_eCtrl.text.trim().isEmpty) _eState = FieldState.error;
        if (_pCtrl.text.isEmpty) _pState = FieldState.error;
      });
      return;
    }
    setState(() => _loading = true);
    try {
      await _authService.registerCustomer(
        username:  _uCtrl.text.trim(),
        email:     _eCtrl.text.trim(),
        password:  _pCtrl.text,
        firstName: _fnCtrl.text.trim(),
        lastName:  _lnCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dibuat!')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeroShell(
      title: 'Buat akun\nAnda',
      subtitle: 'Gratis selamanya. Siap dalam 1 menit.',
      heroFrac: 0.34,
      back: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RqTextField(
            label: 'USERNAME',
            controller: _uCtrl,
            hint: 'Pilih username unik',
            state: _uState,
            error: 'Username wajib diisi',
            suffix: Icons.person_outline_rounded,
            action: TextInputAction.next,
          ),
          const SizedBox(height: 14),

          RqTextField(
            label: 'EMAIL',
            controller: _eCtrl,
            hint: 'nama@email.com',
            state: _eState,
            error: _eErr,
            suffix: _eState == FieldState.error
                ? Icons.info_outline_rounded
                : Icons.mail_outline_rounded,
            keyboard: TextInputType.emailAddress,
            action: TextInputAction.next,
          ),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RqTextField(
                  label: 'NAMA DEPAN',
                  controller: _fnCtrl,
                  hint: 'Nama',
                  state: _fnState,
                  action: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RqTextField(
                  label: 'NAMA BELAKANG',
                  controller: _lnCtrl,
                  hint: 'Belakang',
                  state: _lnState,
                  action: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          RqTextField(
            label: 'PASSWORD',
            controller: _pCtrl,
            hint: 'Minimal 6 karakter',
            obscure: _obscure,
            state: _pState,
            error: _pErr,
            suffix: _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixTap: () => setState(() => _obscure = !_obscure),
            action: TextInputAction.done,
            onSubmit: (_) => _submit(),
          ),

          if (_pCtrl.text.isNotEmpty)
            PasswordStrengthBar(password: _pCtrl.text),

          const SizedBox(height: 24),

          RqButton(
            label: 'Buat akun',
            icon: Icons.check_rounded,
            loading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: 16),

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
          const SizedBox(height: 22),

          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: C.ink2),
                  children: [
                    const TextSpan(text: 'Sudah punya akun? '),
                    TextSpan(
                      text: 'Masuk',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: C.teal500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

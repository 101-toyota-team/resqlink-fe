import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_type_screen.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';
import 'home_screen.dart';
import '../themes/app_theme.dart';
import '../themes/app_widgets.dart';

final AuthService _authService = AuthService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure  = true;
  bool _loading  = false;

  FieldState _unameState = FieldState.idle;
  FieldState _passState  = FieldState.idle;

  @override
  void initState() {
    super.initState();
    _usernameCtrl.addListener(_sync);
    _passwordCtrl.addListener(_sync);
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _sync() => setState(() {
        _unameState = _usernameCtrl.text.trim().isNotEmpty
            ? FieldState.filled : FieldState.idle;
        _passState  = _passwordCtrl.text.isNotEmpty
            ? FieldState.filled : FieldState.idle;
      });

  void _submit() async {
    final emptyU = _usernameCtrl.text.trim().isEmpty;
    final shortP = _passwordCtrl.text.length < 6;
    if (emptyU || shortP) {
      setState(() {
        if (emptyU) _unameState = FieldState.error;
        if (shortP) _passState  = FieldState.error;
      });
      return;
    }
    setState(() => _loading = true);
    try {
      final r = await _authService.login(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      await TokenStorage.saveTokens(
          accessToken: r['access'], refreshToken: r['refresh']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!')));
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeroShell(
      title: 'Selamat\ndatang kembali',
      subtitle: 'Masuk dan akses layanan darurat Anda',
      heroFrac: 0.42,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RqTextField(
            label: 'USERNAME',
            controller: _usernameCtrl,
            hint: 'Masukkan username Anda',
            state: _unameState,
            error: 'Username wajib diisi',
            suffix: Icons.person_outline_rounded,
            action: TextInputAction.next,
          ),
          const SizedBox(height: 14),

          RqTextField(
            label: 'PASSWORD',
            controller: _passwordCtrl,
            hint: 'Minimal 6 karakter',
            obscure: _obscure,
            state: _passState,
            error: 'Password minimal 6 karakter',
            suffix: _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixTap: () => setState(() => _obscure = !_obscure),
            action: TextInputAction.done,
            onSubmit: (_) => _submit(),
          ),
          const SizedBox(height: 10),

          // Forgot
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text('Lupa password?',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: C.teal500)),
            ),
          ),
          const SizedBox(height: 22),

          RqButton(
            label: 'Masuk sekarang',
            icon: Icons.arrow_forward_rounded,
            loading: _loading,
            onPressed: _submit,
          ),

          const OrDivider(),

          RqSosButton(
            label: 'Darurat? Lanjut tanpa akun',
            onPressed: () {},
          ),
          const SizedBox(height: 30),

          // Register link
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RegisterTypeScreen())),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: C.ink2),
                  children: [
                    const TextSpan(text: 'Belum punya akun? '),
                    TextSpan(
                      text: 'Daftar gratis',
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

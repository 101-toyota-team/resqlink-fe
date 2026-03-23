import 'package:flutter/material.dart';
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
  final _formKey            = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;

  FieldState _usernameState = FieldState.idle;
  FieldState _passwordState = FieldState.idle;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onFieldChange);
    _passwordController.addListener(_onFieldChange);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFieldChange() {
    setState(() {
      _usernameState = _usernameController.text.trim().isNotEmpty
          ? FieldState.filled : FieldState.idle;
      _passwordState = _passwordController.text.isNotEmpty
          ? FieldState.filled : FieldState.idle;
    });
  }

  void _submitLogin() async {
    final usernameEmpty = _usernameController.text.trim().isEmpty;
    final passwordShort = _passwordController.text.length < 6;

    if (usernameEmpty || passwordShort) {
      setState(() {
        if (usernameEmpty) _usernameState = FieldState.error;
        if (passwordShort) _passwordState = FieldState.error;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _authService.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      await TokenStorage.saveTokens(
        accessToken: result['access'],
        refreshToken: result['refresh'],
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login sukses: ${result["access"] != null}')),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      heroTitle: 'Selamat datang\nkembali',
      heroSubtitle: 'Masuk ke akun Anda',
      heroFraction: 0.40,
      formContent: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Username',
              controller: _usernameController,
              hintText: 'Masukkan username',
              fieldState: _usernameState,
              errorText: 'Username wajib diisi',
              suffixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),

            AppTextField(
              label: 'Password',
              controller: _passwordController,
              hintText: 'Minimal 6 karakter',
              obscureText: _obscurePassword,
              fieldState: _passwordState,
              errorText: 'Password minimal 6 karakter',
              suffixIcon: _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitLogin(),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Lupa password?',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            AppButton(
              label: 'Masuk',
              icon: Icons.arrow_forward_rounded,
              isLoading: _isLoading,
              onPressed: _submitLogin,
            ),

            const OrDivider(),

            AppSosButton(
              label: 'SOS — Darurat tanpa login',
              onPressed: () {},
            ),
            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun? ',
                    style: TextStyle(fontSize: 14, color: AppColors.text2)),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RegisterTypeScreen()),
                  ),
                  child: Text('Daftar',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

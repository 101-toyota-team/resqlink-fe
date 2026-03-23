import 'package:flutter/material.dart';
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
  final _formKey             = GlobalKey<FormState>();
  final _usernameController  = TextEditingController();
  final _emailController     = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController  = TextEditingController();
  final _passwordController  = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;

  FieldState _usernameState  = FieldState.idle;
  FieldState _emailState     = FieldState.idle;
  FieldState _firstNameState = FieldState.idle;
  FieldState _lastNameState  = FieldState.idle;
  FieldState _passwordState  = FieldState.idle;

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _usernameController, _emailController, _firstNameController,
      _lastNameController, _passwordController,
    ]) {
      c.addListener(_validate);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _usernameState = _usernameController.text.trim().isNotEmpty
          ? FieldState.filled : FieldState.idle;

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailState = FieldState.idle; _emailError = null;
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailState = FieldState.error;
        _emailError = 'Format email tidak valid';
      } else {
        _emailState = FieldState.filled; _emailError = null;
      }

      _firstNameState = _firstNameController.text.trim().isNotEmpty
          ? FieldState.filled : FieldState.idle;
      _lastNameState = _lastNameController.text.trim().isNotEmpty
          ? FieldState.filled : FieldState.idle;

      final pw = _passwordController.text;
      if (pw.isEmpty) {
        _passwordState = FieldState.idle; _passwordError = null;
      } else if (pw.length < 6) {
        _passwordState = FieldState.error;
        _passwordError = 'Password minimal 6 karakter';
      } else {
        _passwordState = FieldState.filled; _passwordError = null;
      }
    });
  }

  void _submitRegister() async {
    final bad = _usernameController.text.trim().isEmpty ||
        _emailState != FieldState.filled ||
        _passwordState != FieldState.filled;

    if (bad) {
      setState(() {
        if (_usernameController.text.trim().isEmpty)
          _usernameState = FieldState.error;
        if (_emailController.text.trim().isEmpty)
          _emailState = FieldState.error;
        if (_passwordController.text.isEmpty)
          _passwordState = FieldState.error;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.registerCustomer(
        username:  _usernameController.text.trim(),
        email:     _emailController.text.trim(),
        password:  _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName:  _lastNameController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Register berhasil')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register gagal: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      heroTitle: 'Buat akun\nbaru',
      heroSubtitle: 'Bergabung dengan layanan darurat digital',
      heroFraction: 0.36,
      backButton: true,
      formContent: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Username',
              controller: _usernameController,
              hintText: 'Pilih username unik',
              fieldState: _usernameState,
              errorText: 'Username wajib diisi',
              suffixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),

            AppTextField(
              label: 'Email',
              controller: _emailController,
              hintText: 'nama@email.com',
              fieldState: _emailState,
              errorText: _emailError,
              suffixIcon: _emailState == FieldState.error
                  ? Icons.info_outline_rounded
                  : Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Nama depan',
                    controller: _firstNameController,
                    hintText: 'Nama',
                    fieldState: _firstNameState,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Nama belakang',
                    controller: _lastNameController,
                    hintText: 'Belakang',
                    fieldState: _lastNameState,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            AppTextField(
              label: 'Password',
              controller: _passwordController,
              hintText: 'Minimal 6 karakter',
              obscureText: _obscurePassword,
              fieldState: _passwordState,
              errorText: _passwordError,
              suffixIcon: _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitRegister(),
            ),

            if (_passwordController.text.isNotEmpty)
              PasswordStrengthBar(password: _passwordController.text),

            const SizedBox(height: 24),

            AppButton(
              label: 'Buat akun',
              icon: Icons.arrow_forward_rounded,
              isLoading: _isLoading,
              onPressed: _submitRegister,
            ),
            const SizedBox(height: 16),

            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.text3,
                      height: 1.6),
                  children: [
                    const TextSpan(text: 'Dengan mendaftar, Anda menyetujui '),
                    TextSpan(
                        text: 'Syarat Layanan',
                        style: TextStyle(color: AppColors.teal)),
                    const TextSpan(text: ' dan '),
                    TextSpan(
                        text: 'Kebijakan Privasi',
                        style: TextStyle(color: AppColors.teal)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun? ',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.text2)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('Masuk',
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

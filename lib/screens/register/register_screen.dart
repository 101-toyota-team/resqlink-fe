import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../globals.dart';
import '../../services/auth_service.dart';
import '../../themes/app_theme.dart';
import '../../themes/app_widgets.dart';
import '../login/login_screen.dart';

/// Customer registration screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final AuthService _authService;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _passwordController;

  bool _isPasswordHidden = true;
  bool _isLoading = false;

  FieldState _usernameState = FieldState.idle;
  FieldState _emailState = FieldState.idle;
  FieldState _firstNameState = FieldState.idle;
  FieldState _lastNameState = FieldState.idle;
  FieldState _passwordState = FieldState.idle;

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _usernameController = TextEditingController()..addListener(_validate);
    _emailController = TextEditingController()..addListener(_validate);
    _firstNameController = TextEditingController()..addListener(_validate);
    _lastNameController = TextEditingController()..addListener(_validate);
    _passwordController = TextEditingController()..addListener(_validate);
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
          ? FieldState.filled
          : FieldState.idle;

      _firstNameState = _firstNameController.text.trim().isNotEmpty
          ? FieldState.filled
          : FieldState.idle;

      _lastNameState = _lastNameController.text.trim().isNotEmpty
          ? FieldState.filled
          : FieldState.idle;

      _validateEmail();
      _validatePassword();
    });
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _emailState = FieldState.idle;
      _emailError = null;
    } else if (!_isValidEmail(email)) {
      _emailState = FieldState.error;
      _emailError = 'Format email tidak valid';
    } else {
      _emailState = FieldState.filled;
      _emailError = null;
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      _passwordState = FieldState.idle;
      _passwordError = null;
    } else if (password.length < AppConstants.passwordMinLength) {
      _passwordState = FieldState.error;
      _passwordError = 'Minimal ${AppConstants.passwordMinLength} karakter';
    } else {
      _passwordState = FieldState.filled;
      _passwordError = null;
    }
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  bool _validateInputs() {
    if (_usernameController.text.trim().isEmpty ||
        _emailState != FieldState.filled ||
        _passwordState != FieldState.filled) {
      setState(() {
        if (_usernameController.text.trim().isEmpty) {
          _usernameState = FieldState.error;
        }
        if (_emailState != FieldState.filled) _emailState = FieldState.error;
        if (_passwordState != FieldState.filled) _passwordState = FieldState.error;
      });
      return false;
    }
    return true;
  }

  Future<void> _handleRegister() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.registerCustomer(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (!mounted) return;
      _showSuccessMessage('Akun berhasil dibuat!');
      _navigateToLogin();
    } on AuthException catch (e) {
      _showErrorMessage(e.message);
    } catch (e) {
      _showErrorMessage('Pendaftaran gagal. Silakan coba lagi.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: C.teal500,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: C.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordHidden = !_isPasswordHidden);
  }

  @override
  Widget build(BuildContext context) {
    return HeroShell(
      title: 'Buat akun\nAnda',
      subtitle: 'Siap dalam 1 menit.',
      heroFrac: 0.34,
      back: true,
      logoRight: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsernameField(),
          const SizedBox(height: 14),
          _buildEmailField(),
          const SizedBox(height: 14),
          _buildNameFields(),
          const SizedBox(height: 14),
          _buildPasswordField(),
          if (_passwordController.text.isNotEmpty)
            PasswordStrengthBar(password: _passwordController.text),
          const SizedBox(height: 24),
          _buildRegisterButton(),
          const SizedBox(height: 16),
          _buildTermsText(),
          const SizedBox(height: 22),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() => RqTextField(
    label: 'USERNAME',
    controller: _usernameController,
    hint: 'Pilih username unik',
    state: _usernameState,
    error: 'Username wajib diisi',
    suffix: Icons.person_outline_rounded,
    action: TextInputAction.next,
  );

  Widget _buildEmailField() => RqTextField(
    label: 'EMAIL',
    controller: _emailController,
    hint: 'nama@email.com',
    state: _emailState,
    error: _emailError,
    suffix: _emailState == FieldState.error
        ? Icons.info_outline_rounded
        : Icons.mail_outline_rounded,
    keyboard: TextInputType.emailAddress,
    action: TextInputAction.next,
  );

  Widget _buildNameFields() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: RqTextField(
          label: 'NAMA DEPAN',
          controller: _firstNameController,
          hint: 'Nama',
          state: _firstNameState,
          action: TextInputAction.next,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: RqTextField(
          label: 'NAMA BELAKANG',
          controller: _lastNameController,
          hint: 'Belakang',
          state: _lastNameState,
          action: TextInputAction.next,
        ),
      ),
    ],
  );

  Widget _buildPasswordField() => RqTextField(
    label: 'PASSWORD',
    controller: _passwordController,
    hint: 'Minimal 6 karakter',
    obscure: _isPasswordHidden,
    state: _passwordState,
    error: _passwordError,
    suffix: _isPasswordHidden
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined,
    onSuffixTap: _togglePasswordVisibility,
    action: TextInputAction.done,
    onSubmit: (_) => _handleRegister(),
  );

  Widget _buildRegisterButton() => RqButton(
    label: 'Buat akun',
    icon: Icons.check_rounded,
    loading: _isLoading,
    onPressed: _handleRegister,
  );

  Widget _buildTermsText() => Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: C.ink3,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: 'Dengan mendaftar Anda menyetujui '),
          TextSpan(
            text: 'Syarat Layanan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: C.teal500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' dan '),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: C.teal500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildLoginLink() => Center(
    child: GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: C.ink2),
          children: [
            const TextSpan(text: 'Sudah punya akun? '),
            TextSpan(
              text: 'Masuk',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: C.teal500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../services/auth_helper.dart';
import '../../utils/error_handler.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../themes/app_widgets.dart';
import '../login/login_screen.dart';

/// Customer registration screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      await AuthHelper.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (!mounted) return;
      
      _showSuccessMessage('Akun berhasil dibuat! Silakan login dengan email Anda.');
      
      // Navigate back to login after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) _navigateToLogin();
    } catch (e) {
      _showErrorMessage(ErrorHandler.getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
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
      heroFrac: 0.3,
      back: true,
      logoRight: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsernameField(),
          const SizedBox(height: 18),
          _buildEmailField(),
          const SizedBox(height: 18),
          _buildNameFields(),
          const SizedBox(height: 18),
          _buildPasswordField(),
          if (_passwordController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: PasswordStrengthBar(password: _passwordController.text),
            ),
          const SizedBox(height: 32),
          _buildRegisterButton(),
          const SizedBox(height: 20),
          _buildTermsText(),
          const SizedBox(height: 32),
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
      const SizedBox(width: 14),
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
    label: 'Buat akun sekarang',
    icon: Icons.check_rounded,
    loading: _isLoading,
    onPressed: _handleRegister,
  );

  Widget _buildTermsText() => Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTypography.caption.copyWith(
          color: AppColors.textGrey,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: 'Dengan mendaftar Anda menyetujui '),
          TextSpan(
            text: 'Syarat Layanan',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: ' dan '),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
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
          style: AppTypography.body.copyWith(color: AppColors.textDark),
          children: [
            const TextSpan(text: 'Sudah punya akun? '),
            TextSpan(
              text: 'Masuk',
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

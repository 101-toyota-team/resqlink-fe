import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../../services/auth_service.dart';
import '../../constants/app_colors.dart';
import '../../themes/app_widgets.dart';
import '../register/register_screen.dart';
import '../home/home_screen.dart';
import '../../services/auth_helper.dart';
import '../main_navigation.dart';


/// Login screen for existing users
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late final AuthService _authService;
  late final AuthHelper _authHelper;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  bool _isPasswordHidden = true;
  bool _isLoading = false;

  FieldState _usernameFieldState = FieldState.idle;
  FieldState _passwordFieldState = FieldState.idle;

  @override
  void initState() {
    super.initState();
    // _authService = AuthService();
    _authHelper = AuthHelper();
    _usernameController = TextEditingController()..addListener(_validateUsername);
    _passwordController = TextEditingController()..addListener(_validatePassword);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    setState(() {
      _usernameFieldState = _usernameController.text.trim().isNotEmpty
          ? FieldState.filled
          : FieldState.idle;
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordFieldState = _passwordController.text.isNotEmpty
          ? FieldState.filled
          : FieldState.idle;
    });
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordHidden = !_isPasswordHidden);
  }

  Future<void> _handleLogin() async {
  if (!_validateInputs()) return;

  print("hola");

  setState(() => _isLoading = true);

  try {
    await AuthHelper.login(
      email: _usernameController.text.trim(), 
      password: _passwordController.text,
    );

    // await AuthHelper.testPing();

    // print(apalah);

    if (!mounted) return;

    _navigateToMain();
    _showSuccessMessage('Login berhasil!');

  } catch (e) {
    _showErrorMessage('Login gagal. Periksa email dan password.');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  // Future<void> _handleLogin() async {
  //   // Validate inputs
  //   if (!_validateInputs()) return;

  //   setState(() => _isLoading = true);

  //   try {
  //     final result = await _authHelper.login(
  //       email: _usernameController.text.trim(),
  //       password: _passwordController.text,
  //     );

  //     await TokenStorage.saveTokens(
  //       accessToken: result['access'] as String? ?? '',
  //       refreshToken: result['refresh'] as String? ?? '',
  //     );

  //     if (!mounted) return;
  //     _navigateToMain();
  //     _showSuccessMessage('Login berhasil!');
  //   } on AuthException catch (e) {
  //     _showErrorMessage(e.message);
  //   } catch (e) {
  //     _showErrorMessage('Login gagal. Periksa kembali username dan password Anda.');
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  bool _validateInputs() {
    final usernameEmpty = _usernameController.text.trim().isEmpty;
    final passwordTooShort = _passwordController.text.length < 6;

    if (usernameEmpty || passwordTooShort) {
      setState(() {
        if (usernameEmpty) _usernameFieldState = FieldState.error;
        if (passwordTooShort) _passwordFieldState = FieldState.error;
      });
      return false;
    }

    return true;
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB91212),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeroShell(
      title: 'Selamat\ndatang kembali',
      subtitle: 'Masuk dan akses layanan darurat Anda',
      heroFrac: 0.42,
      back: true,
      logoRight: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsernameField(),
          const SizedBox(height: 14),
          _buildPasswordField(),
          const SizedBox(height: 10),
          _buildForgotPasswordLink(),
          const SizedBox(height: 22),
          _buildLoginButton(),
          const SizedBox(height: 30),
          _buildRegisterLink(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() => RqTextField(
    label: 'USERNAME',
    controller: _usernameController,
    hint: 'Masukkan username Anda',
    state: _usernameFieldState,
    error: 'Username wajib diisi',
    suffix: Icons.person_outline_rounded,
    action: TextInputAction.next,
  );

  Widget _buildPasswordField() => RqTextField(
    label: 'PASSWORD',
    controller: _passwordController,
    hint: 'Minimal 6 karakter',
    obscure: _isPasswordHidden,
    state: _passwordFieldState,
    error: 'Password minimal 6 karakter',
    suffix: _isPasswordHidden
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined,
    onSuffixTap: _togglePasswordVisibility,
    action: TextInputAction.done,
    onSubmit: (_) => _handleLogin(),
  );

  Widget _buildForgotPasswordLink() => Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () {
        // TODO: Implement forgot password flow
      },
      child: Text(
        'Lupa password?',
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFB91212),
        ),
      ),
    ),
  );

  Widget _buildLoginButton() => RqButton(
    label: 'Masuk sekarang',
    icon: Icons.arrow_forward_rounded,
    loading: _isLoading,
    onPressed: _handleLogin,
  );

  Widget _buildRegisterLink() => Center(
    child: GestureDetector(
      onTap: _navigateToRegister,
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textDark),
          children: [
            const TextSpan(text: 'Belum punya akun? '),
            TextSpan(
              text: 'Daftar gratis',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFB91212),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

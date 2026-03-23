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
  final _formKey = GlobalKey<FormState>();

  final _companyNameController  = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _phoneController        = TextEditingController();
  final _addressController      = TextEditingController();
  final _licenseController      = TextEditingController();
  final _adminUserController    = TextEditingController();
  final _adminPassController    = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;
  int  _step            = 0;

  FieldState _companyNameState  = FieldState.idle;
  FieldState _companyEmailState = FieldState.idle;
  FieldState _phoneState        = FieldState.idle;
  FieldState _addressState      = FieldState.idle;
  FieldState _licenseState      = FieldState.idle;
  FieldState _adminUserState    = FieldState.idle;
  FieldState _adminPassState    = FieldState.idle;

  String? _emailError;
  String? _passError;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _companyNameController, _companyEmailController, _phoneController,
      _addressController, _licenseController,
      _adminUserController, _adminPassController,
    ]) c.addListener(_validate);
  }

  @override
  void dispose() {
    for (final c in [
      _companyNameController, _companyEmailController, _phoneController,
      _addressController, _licenseController,
      _adminUserController, _adminPassController,
    ]) c.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _companyNameState = _companyNameController.text.trim().isNotEmpty
          ? FieldState.filled : FieldState.idle;

      final email = _companyEmailController.text.trim();
      if (email.isEmpty) {
        _companyEmailState = FieldState.idle; _emailError = null;
      } else if (!email.contains('@') || !email.contains('.')) {
        _companyEmailState = FieldState.error;
        _emailError = 'Format email tidak valid';
      } else {
        _companyEmailState = FieldState.filled; _emailError = null;
      }

      _phoneState   = _phoneController.text.trim().isNotEmpty   ? FieldState.filled : FieldState.idle;
      _addressState = _addressController.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;
      _licenseState = _licenseController.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;
      _adminUserState = _adminUserController.text.trim().isNotEmpty ? FieldState.filled : FieldState.idle;

      final pw = _adminPassController.text;
      if (pw.isEmpty) {
        _adminPassState = FieldState.idle; _passError = null;
      } else if (pw.length < 6) {
        _adminPassState = FieldState.error;
        _passError = 'Password minimal 6 karakter';
      } else {
        _adminPassState = FieldState.filled; _passError = null;
      }
    });
  }

  void _next() {
    if (_step == 0) {
      if (_companyNameState != FieldState.filled ||
          _companyEmailState != FieldState.filled ||
          _phoneState != FieldState.filled) {
        setState(() {
          if (_companyNameController.text.trim().isEmpty)
            _companyNameState = FieldState.error;
          if (_companyEmailController.text.trim().isEmpty)
            _companyEmailState = FieldState.error;
          if (_phoneController.text.trim().isEmpty)
            _phoneState = FieldState.error;
        });
        return;
      }
      setState(() => _step = 1);
    } else {
      _submit();
    }
  }

  void _submit() async {
    if (_adminUserState != FieldState.filled ||
        _adminPassState != FieldState.filled) {
      setState(() {
        if (_adminUserController.text.trim().isEmpty)
          _adminUserState = FieldState.error;
        if (_adminPassController.text.isEmpty)
          _adminPassState = FieldState.error;
      });
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: API call
    if (!mounted) return;
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
          onDone: () => Navigator.of(context).popUntil((r) => r.isFirst)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      heroTitle: _step == 0 ? 'Data\nperusahaan' : 'Akun\nadmin utama',
      heroSubtitle: _step == 0
          ? 'Informasi institusi penyedia layanan'
          : 'Admin yang mengelola platform provider',
      heroFraction: 0.34,
      backButton: true,
      formContent: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepBar(step: _step),
            const SizedBox(height: 22),

            if (_step == 0) ...[
              AppTextField(
                label: 'Nama perusahaan / institusi',
                controller: _companyNameController,
                hintText: 'contoh: RS Pondok Indah',
                fieldState: _companyNameState,
                errorText: 'Nama perusahaan wajib diisi',
                suffixIcon: Icons.business_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Email resmi perusahaan',
                controller: _companyEmailController,
                hintText: 'admin@perusahaan.com',
                fieldState: _companyEmailState,
                errorText: _emailError,
                suffixIcon: _companyEmailState == FieldState.error
                    ? Icons.info_outline_rounded
                    : Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Nomor telepon',
                controller: _phoneController,
                hintText: '+62 21 xxxx xxxx',
                fieldState: _phoneState,
                errorText: 'Nomor telepon wajib diisi',
                suffixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Alamat (opsional)',
                controller: _addressController,
                hintText: 'Jl. ...',
                fieldState: _addressState,
                suffixIcon: Icons.location_on_outlined,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Nomor izin operasional (opsional)',
                controller: _licenseController,
                hintText: 'No. izin ambulans',
                fieldState: _licenseState,
                suffixIcon: Icons.badge_outlined,
                textInputAction: TextInputAction.done,
              ),
            ],

            if (_step == 1) ...[
              // Info box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.tealBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 16, color: AppColors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Akun ini akan menjadi admin utama yang bisa menambah driver, dispatcher, dan admin lainnya.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppColors.tealDeep,
                          height: 1.55,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Username admin',
                controller: _adminUserController,
                hintText: 'Pilih username unik',
                fieldState: _adminUserState,
                errorText: 'Username wajib diisi',
                suffixIcon: Icons.manage_accounts_outlined,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Password',
                controller: _adminPassController,
                hintText: 'Minimal 6 karakter',
                obscureText: _obscurePassword,
                fieldState: _adminPassState,
                errorText: _passError,
                suffixIcon: _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_adminPassController.text.isNotEmpty)
                PasswordStrengthBar(password: _adminPassController.text),
            ],

            const SizedBox(height: 24),

            AppButton(
              label: _step == 0 ? 'Lanjutkan' : 'Daftarkan Provider',
              icon: _step == 0
                  ? Icons.arrow_forward_rounded
                  : Icons.check_rounded,
              isLoading: _isLoading,
              onPressed: _next,
            ),

            if (_step == 1) ...[
              const SizedBox(height: 14),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _step = 0),
                  child: Text(
                    'Kembali ke data perusahaan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 12, color: AppColors.text3, height: 1.6),
                  children: [
                    const TextSpan(
                        text: 'Dengan mendaftar, Anda menyetujui '),
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
          ],
        ),
      ),
    );
  }
}

// ── Step bar ──────────────────────────────────────────────────────────────────
class _StepBar extends StatelessWidget {
  const _StepBar({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(2, (i) {
        final active = i == step;
        final done   = i < step;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 1 ? 10 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: done || active ? AppColors.teal : AppColors.sep,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  i == 0 ? 'Data perusahaan' : 'Akun admin',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.w400,
                    color: active ? AppColors.teal : AppColors.text3,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Success dialog ────────────────────────────────────────────────────────────
class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: const BoxDecoration(
                color: AppColors.tealSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.teal, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              'Provider terdaftar!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Akun provider Anda sedang diverifikasi. '
              'Anda akan mendapat notifikasi dalam 1×24 jam.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: AppColors.text2,
                height: 1.55,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealDeep,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Kembali ke beranda',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

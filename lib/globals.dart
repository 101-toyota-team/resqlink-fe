/// ResQLink Application Constants
class AppConstants {
  AppConstants._();

  // ─────────────────────────────────────────
  // API Configuration
  // ─────────────────────────────────────────
  static const String apiBaseUrl = 'http://10.0.2.2:8000';

  // ─────────────────────────────────────────
  // Durations
  // ─────────────────────────────────────────
  static const Duration animationDuration = Duration(milliseconds: 260);
  static const Duration longAnimationDuration = Duration(milliseconds: 380);
  static const Duration shortAnimationDuration = Duration(milliseconds: 140);

  // ─────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────
  static const int passwordMinLength = 6;
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
}

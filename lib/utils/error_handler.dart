class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Network Errors
    if (errorString.contains('socketexception') || 
        errorString.contains('connection timed out') ||
        errorString.contains('failed host lookup')) {
      return 'Koneksi internet terputus. Silakan periksa jaringan Anda.';
    }

    // HTTP Status Codes
    if (errorString.contains('500')) {
      return 'Terjadi gangguan pada server kami. Tim teknis sedang menanganinya.';
    }
    if (errorString.contains('404')) {
      return 'Layanan atau data yang Anda cari tidak ditemukan.';
    }
    if (errorString.contains('403') || errorString.contains('401')) {
      return 'Sesi Anda telah berakhir atau Anda tidak memiliki akses. Silakan masuk kembali.';
    }
    if (errorString.contains('502') || errorString.contains('503') || errorString.contains('504')) {
      return 'Server sedang sibuk atau dalam pemeliharaan. Silakan coba beberapa saat lagi.';
    }

    // Specific Backend Messages (Mapped to Friendly Text)
    if (errorString.contains('user already registered') || errorString.contains('already exists')) {
      return 'Email atau nomor telepon sudah terdaftar. Silakan gunakan yang lain atau masuk.';
    }
    if (errorString.contains('invalid login credentials') || errorString.contains('invalid password')) {
      return 'Email atau kata sandi yang Anda masukkan salah.';
    }
    if (errorString.contains('rate limit')) {
      return 'Terlalu banyak permintaan. Silakan tunggu sebentar sebelum mencoba lagi.';
    }

    // Default Error
    return 'Terjadi kesalahan sistem yang tidak terduga. Silakan coba lagi nanti.';
  }
}

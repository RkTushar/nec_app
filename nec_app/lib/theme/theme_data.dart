import 'package:flutter/material.dart';

/// Centralized app color palette and theme configuration.
class AppColors {
  AppColors._();

  // Brand greens seen across the app
  static const Color primary = Color(0xFF4CAF50); // main brand green
  static const Color primaryAlt = Color(0xFF19A250); // alt green used on home
  static const Color primaryLight = Color(0xFF81C784); // lighter green for invite button 2
  static const Color primaryDark = Color(0xFF1B5E20); // deep green accents (prev FAB edge)
  static const Color selected = Color(0xFF388E3C); // matches previous selected tab green (green700)

  // Accents and status
  static const Color accentBlue = Color(0xFF1E88E5);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32); // prev FAB center green
  static const Color whatsapp = Color(0xFF25D366);

  // Neutrals
  static const Color scaffoldBg = Color(0xFFF8F8F8);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE6E6E6);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color inputBorder = Color(0x59000000); // approx grey 500 @ 35%
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const Color primary = AppColors.primary;
    return ThemeData(
      useMaterial3: false,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: AppColors.accentBlue,
        error: AppColors.error,
        surface: AppColors.card,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      dividerColor: AppColors.divider,
      cardColor: AppColors.card,
    );
  }
}



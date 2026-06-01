import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _cardRadius = 20.0;
  static const _buttonRadius = 14.0;

  static TextTheme get _poppinsTextTheme => GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 46, fontWeight: FontWeight.w700, letterSpacing: -1.2),
          displayMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.8),
          displaySmall: TextStyle(fontSize: 27, fontWeight: FontWeight.w700, letterSpacing: -0.7),
          headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.3),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.6),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.6),
        ),
      );

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.green,
        onPrimary: Colors.white,
        secondary: AppColors.saffron,
        onSecondary: Colors.white,
        surface: AppColors.bg,
        onSurface: AppColors.ink,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: _poppinsTextTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );

    return base.copyWith(
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          side: const BorderSide(color: AppColors.line),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.line2,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.line2),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.green,
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
          borderSide: const BorderSide(color: AppColors.line2, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
          borderSide: const BorderSide(color: AppColors.line2, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.ink3, fontSize: 14.5),
        labelStyle: GoogleFonts.poppins(color: AppColors.ink2, fontSize: 12.5, fontWeight: FontWeight.w600),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.94),
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.ink3,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.card,
        side: const BorderSide(color: AppColors.line2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500, color: AppColors.ink2),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 0,
      ),
    );
  }

  static ThemeData get dark {
    return light.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.darkSaffron,
        onSecondary: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
        error: AppColors.darkError,
      ),
      scaffoldBackgroundColor: AppColors.darkBg,
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          side: const BorderSide(color: Color(0xFF22332C)),
        ),
      ),
    );
  }
}

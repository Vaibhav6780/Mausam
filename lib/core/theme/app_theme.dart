import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryNavy,
        primary: AppColors.primaryNavy,
        secondary: AppColors.skyBlue,
        tertiary: AppColors.freshTeal,
        background: AppColors.background,
        surface: AppColors.white,
        error: AppColors.danger,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onBackground: AppColors.deepNavy,
        onSurface: AppColors.deepNavy,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: AppColors.secondaryText, fontWeight: FontWeight.normal),
        bodyMedium: GoogleFonts.inter(color: AppColors.secondaryText, fontWeight: FontWeight.normal),
        bodySmall: GoogleFonts.inter(color: AppColors.mutedText, fontWeight: FontWeight.normal),
        labelLarge: GoogleFonts.inter(color: AppColors.deepNavy, fontWeight: FontWeight.w600),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          side: const BorderSide(color: AppColors.primaryNavy),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.deepNavy),
        titleTextStyle: TextStyle(
          color: AppColors.deepNavy,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryNavy,
        unselectedItemColor: AppColors.mutedText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}

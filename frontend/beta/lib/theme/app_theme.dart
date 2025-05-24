import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF7B68EE), // Soft lavender - calming and modern
        secondary: Color(0xFF4ECDC4), // Mint green - fresh and soothing
        tertiary: Color(0xFFFF9F9F), // Soft coral - gentle and warm
        background: Color(0xFF1E1E2E), // Deep navy - reduces eye strain
        surface: Color(0xFF2D2D44), // Lighter navy - maintains contrast
        error: Color(0xFFFF6B6B), // Soft red - less harsh
        onPrimary: Colors.white,
        onSecondary: Color(0xFF1E1E2E), // Dark text on light backgrounds
        onBackground: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.readexPro(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.readexPro(
          fontSize: 14,
          color: Colors.white70,
        ),
        labelLarge: GoogleFonts.readexPro(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2D2D44).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFF7B68EE), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFFFF6B6B)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        labelStyle: GoogleFonts.readexPro(
          color: Colors.white70,
          fontSize: 15,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF7B68EE),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

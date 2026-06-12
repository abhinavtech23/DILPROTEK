import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🏥 Modern Medical Palette
  static const Color primaryTeal = Color(0xFF0D9488); // Darker, richer teal
  static const Color secondaryTeal = Color(0xFF2DD4BF); // Brighter accent
  static const Color alertRed = Color(0xFFEF4444);
  static const Color safeGreen = Color(0xFF10B981);
  static const Color darkNavy = Color(0xFF0F172A); // Professional text color
  static const Color softGrey = Color(0xFFF1F5F9); // Background

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: softGrey,
    primaryColor: primaryTeal,
    
    // 🔤 Typography
    textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: darkNavy,
      displayColor: darkNavy,
    ),

    // 🎨 AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: darkNavy, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: darkNavy),
    ),

    // 🔘 Button Theme (Pill shaped, gradient-like feel)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // 🃏 Card Theme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
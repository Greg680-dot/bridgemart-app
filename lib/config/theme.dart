import 'package:flutter/material.dart';

class AppTheme {
  // Brand Identity — BridgeMart (Proposal 2)
  static const Color bridgeGreen = Color(0xFF008751); // Primary: buttons, app bar, icon
  static const Color deepGreen = Color(0xFF006B3F);   // Headings, links, success messages
  static const Color marketYellow = Color(0xFFFCD116); // Accent: promotions, badges, 'Order now' button
  static const Color signalRed = Color(0xFFE8112D);   // Highlights & errors: failed payment, disputes
  static const Color ink = Color(0xFF10201A);         // Main text
  static const Color textSecondary = Color(0xFF4F5E56); // Secondary gray-green text
  static const Color background = Color(0xFFFAFAF5);  // Warm neutral background
  static const Color surface = Color(0xFFEEF0E6);     // Neutral surface
  static const Color border = Color(0xFFE2E4DA);      // Subtle divider/border
  static const Color greenTint = Color(0xFFE3F2EA);   // Verified badges & soft containers

  // Aliases for compatibility
  static const Color primary = bridgeGreen;
  static const Color primaryLight = greenTint;
  static const Color secondary = deepGreen;
  static const Color accent = marketYellow;
  static const Color error = signalRed;
  static const Color success = deepGreen;
  static const Color warning = marketYellow;
  static const Color textPrimary = ink;
  static const Color textMuted = textSecondary;
  static const Color cardColor = Colors.white;

  // Regional & Country branding
  static const Color nigeriaGreen = bridgeGreen;
  static const Color beninGreen = deepGreen;
  static const Color beninYellow = marketYellow;
  static const Color beninRed = signalRed;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',
      colorScheme: const ColorScheme.light(
        primary: bridgeGreen,
        secondary: deepGreen,
        surface: Colors.white,
        background: background,
        error: signalRed,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: ink),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bridgeGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepGreen,
          side: const BorderSide(color: deepGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: bridgeGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: signalRed, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
    );
  }
}

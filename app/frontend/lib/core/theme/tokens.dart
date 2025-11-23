import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens extracted to align with the TS prototype.
class AppTokens {
  // Colors
  static const Color primary = Color(0xFF2257D8);
  static const Color primaryMuted = Color(0xFFE6EEFF);
  static const Color surface = Color(0xFFF6F8FB);
  static const Color textStrong = Color(0xFF0F172A);
  static const Color textWeak = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Spacing
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;

  // Radius
  static const double radius4 = 8;
  static const double radius5 = 12;

  // Typography
  static final TextStyle heading = GoogleFonts.notoSans(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: textStrong,
  );

  static final TextStyle body = GoogleFonts.notoSans(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: textStrong,
  );

  static final TextStyle caption = GoogleFonts.notoSans(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: textWeak,
  );
}

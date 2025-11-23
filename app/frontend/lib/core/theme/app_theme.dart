import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _brandPrimary = Color(0xFF2257D8);
  static const _brandSurface = Color(0xFFF6F8FB);

  static ThemeData get light {
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: _brandPrimary,
        primaryContainer: Color(0xFFD9E4FF),
        secondary: Color(0xFF0F2C6E),
        secondaryContainer: Color(0xFFE3EBFF),
        tertiary: Color(0xFF0FB5B3),
        tertiaryContainer: Color(0xFFE0F7F5),
        appBarColor: _brandPrimary,
        error: Color(0xFFBA1A1A),
      ),
      scaffoldBackground: _brandSurface,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        useM2StyleDividerInM3: true,
        useMaterial3Typography: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  static ThemeData get dark {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: _brandPrimary,
        primaryContainer: Color(0xFF0C2F7A),
        secondary: Color(0xFF4C6EF5),
        secondaryContainer: Color(0xFF1C2F5C),
        tertiary: Color(0xFF21D6D4),
        tertiaryContainer: Color(0xFF0D3B3A),
        appBarColor: _brandPrimary,
        error: Color(0xFFFFB4A9),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 15,
      subThemesData: const FlexSubThemesData(
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        useM2StyleDividerInM3: true,
        useMaterial3Typography: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }
}

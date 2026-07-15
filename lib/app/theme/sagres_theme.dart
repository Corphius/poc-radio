import 'package:flutter/material.dart';

abstract final class SagresColors {
  static const red = Color(0xFF983B2E);
  static const deepRed = Color(0xFF64251E);
  static const yellow = Color(0xFFFCAF26);
  static const orange = Color(0xFFF58229);
  static const background = Color(0xFFFFFAF3);
  static const ink = Color(0xFF33201D);
}

abstract final class SagresTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: SagresColors.red,
      brightness: Brightness.light,
      primary: SagresColors.red,
      secondary: SagresColors.yellow,
      surface: SagresColors.background,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: SagresColors.background,
      fontFamily: 'sans-serif',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w900),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: SagresColors.yellow.withValues(alpha: .35),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}

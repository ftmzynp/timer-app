import 'package:flutter/material.dart';

// Seçilen palet renkleri
const Color _primaryPurple = Color(0xFFA297B4); // ana vurgu rengi
const Color _secondaryGrayBlue = Color(0xFFBFC8CF); // yardımcı
const Color _darkBg = Color(0xFF26212A); // arka plan

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: _primaryPurple,
    secondary: _secondaryGrayBlue,
    surface: _secondaryGrayBlue, // biraz daha açık yüzey
    background: _darkBg,
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: _darkBg,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2E2A34),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  cardColor: const Color(0xFF2E2A34),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF383141), // surface’den biraz koyu
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primaryPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF2E2A34),
    selectedItemColor: _primaryPurple,
    unselectedItemColor: Colors.grey,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF383141),
    selectedColor: _primaryPurple.withOpacity(0.2),
    secondarySelectedColor: _primaryPurple,
    labelStyle: const TextStyle(color: Colors.white),
    secondaryLabelStyle: const TextStyle(color: Colors.black),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
  ),
);
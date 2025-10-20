import 'package:flutter/material.dart';

// 🎨 Renk Paleti
const Color kPrimaryGreen = Color(0xFF9AA285); // ana yeşil
const Color kAccentOrange = Color(0xFFE7A57C); // vurgu rengi
const Color kBeigeSurface = Color(0xFFE3D2A4); // arka plan/surface
const Color kHelperBlue = Color(0xFF507176);   // yardımcı renk

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: kPrimaryGreen,
    secondary: kAccentOrange,
    surface: kAccentOrange,
    background: Color(0xFFFDFBF7), // çok açık bej tonlu arkaplan
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFFDFBF7),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBeigeSurface,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  cardColor: kBeigeSurface,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kBeigeSurface.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.black54),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kBeigeSurface,
    selectedItemColor: kPrimaryGreen,
    unselectedItemColor: kHelperBlue,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: kBeigeSurface.withOpacity(0.6),
    selectedColor: kPrimaryGreen.withOpacity(0.3),
    secondarySelectedColor: kPrimaryGreen,
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        color: kPrimaryGreen, fontSize: 36, fontWeight: FontWeight.bold),
  ),
);
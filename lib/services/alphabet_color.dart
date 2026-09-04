import 'package:flutter/material.dart';

class DarkAlphabetColorManager {
  // A palette of dark, professional colors (Material Shade 800/900)
  static const List<Color> _darkPalette = [
    Color(0xFF2C3E50), // Midnight Blue
    Color(0xFF8E44AD), // Dark Wisteria (Purple)
    Color(0xFF2980B9), // Belize Hole (Blue)
    Color(0xFF27AE60), // Nephritis (Green)
    Color(0xFFD35400), // Pumpkin (Dark Orange)
    Color(0xFFC0392B), // Pomegranate (Dark Red)
    Color(0xFF16A085), // Green Sea (Teal)
    Color(0xFFF39C12), // Orange (Deep)
    Color(0xFF7F8C8D), // Asbestos (Grey)
    Color(0xFF1B2631), // Very Dark Blue
    Color(0xFF512DA8), // Deep Purple 700
    Color(0xFF1B5E20), // Dark Green 900
    Color(0xFF0D47A1), // Dark Blue 900
    Color(0xFF3E2723), // Dark Brown 900
    Color(0xFF212121), // Grey 900
    Color(0xFF311B92), // Deep Purple 900
  ];

  /// Function to get a dark color based on the first letter of a string
  static Color getColor(String? text) {
    if (text == null || text.isEmpty) return const Color(0xFF212121);

    // Normalize input
    String char = text.trim()[0].toUpperCase();
    
    // Get unique index using code units
    int charCode = char.codeUnitAt(0);
    int index = charCode % _darkPalette.length;

    return _darkPalette[index];
  }
}
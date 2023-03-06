import 'package:flutter/material.dart';

class FlutteringColors {
  static final FlutteringColors _instance = FlutteringColors();
  static FlutteringColors get instance => _instance;

  // 1. Background (0dp elevation surface overlay)
  // 2. Surface (with 1dp elevation surface overlay)
  // 3. Primary
  // 4. Secondary
  // 5. On background
  // 6. On Surface
  // 7. On Primary
  // 8. On Secondary

  /// LIGHT MODE
  Color get lightBackground => white;/// background
  Color get lightSurface => white; /// card or block with shadow to user see different between background and block
  Color get lightPrimary => const Color.fromRGBO(98, 0, 38, 1); /// theme mode (button, title)
  Color get lightSecondary => const Color.fromRGBO(56, 0, 179, 1); /// theme mode (button, title)
  Color get lightOnBackground => const Color.fromRGBO(5, 5, 5, 1); /// text on background
  Color get lightOnSurface => const Color.fromRGBO(11, 11, 11, 1); /// text on card or block
  Color get lightOnPrimary => const Color.fromRGBO(235, 235, 235, 1); /// text on theme mode
  Color get lightOnSecondary => const Color.fromRGBO(235, 235, 235, 1); /// text on theme mode
  
  /// DARK MODE
  Color get darkBackground => gray00db; /// background
  Color get darkSurface => gray01db; /// card or block
  Color get darkPrimary => const Color.fromRGBO(187, 134, 152, 1); /// theme mode (button, title)
  Color get darkSecondary => const Color.fromRGBO(3, 218, 198, 1); /// theme mode (button, title)
  Color get darkOnBackground => const Color.fromRGBO(213, 213, 213, 1); /// text on background
  Color get darkOnSurface => const Color.fromRGBO(224, 224, 224, 1); /// text on card or block
  Color get darkOnPrimary => black; /// text on theme mode
  Color get darkOnSecondary => black; /// text on theme mode

  /// BASE
  Color get black => const Color.fromRGBO(0, 0, 0, 1);
  Color get white => const Color.fromRGBO(255, 255, 255, 1);

  /// GRAY
  Color get gray00db => const Color.fromRGBO(18, 18, 18, 1);
  Color get gray01db => const Color.fromRGBO(30, 30, 30, 1);
  Color get gray02db => const Color.fromRGBO(34, 34, 34, 1);
  Color get gray03db => const Color.fromRGBO(36, 36, 36, 1);
  Color get gray04db => const Color.fromRGBO(39, 39, 39, 1);
  Color get gray06db => const Color.fromRGBO(44, 44, 44, 1);
  Color get gray08db => const Color.fromRGBO(46, 46, 46, 1);
  Color get gray12db => const Color.fromRGBO(51, 51, 51, 1);
  Color get gray16db => const Color.fromRGBO(53, 53, 53, 1);
  Color get gray24db => const Color.fromRGBO(56, 56, 56, 1);

}
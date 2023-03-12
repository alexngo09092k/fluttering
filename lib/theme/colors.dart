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
  Color get lightPrimary => const Color.fromRGBO(109, 124, 238, 1); /// theme mode (button, title)
  Color get lightSecondary => const Color.fromRGBO(113, 184, 205, 1); /// theme mode (button, title)
  Color get lightOnBackground => const Color.fromRGBO(5, 5, 5, 1); /// text on background
  Color get lightOnSurface => const Color.fromRGBO(11, 11, 11, 1); /// text on card or block
  Color get lightOnPrimary => const Color.fromRGBO(235, 235, 235, 1); /// text on theme mode
  Color get lightOnSecondary => const Color.fromRGBO(235, 235, 235, 1); /// text on theme mode
  Color get lightError => const Color.fromARGB(255, 195, 7, 1); /// warning, error, failed
  Color get lightOnError => lightOnPrimary; /// text on warning, error, failed

  /// DARK MODE
  Color get darkBackground => const Color.fromRGBO(21, 25, 35, 1); /// background
  Color get darkSurface => const Color.fromRGBO(19, 22, 31, 1); /// card or block
  Color get darkPrimary => const Color.fromRGBO(109, 124, 238, 1); /// theme mode (button, title)
  Color get darkSecondary => const Color.fromRGBO(113, 184, 205, 1); /// theme mode (button, title)
  Color get darkOnBackground => const Color.fromRGBO(213, 213, 213, 1); /// text on background
  Color get darkOnSurface => const Color.fromRGBO(224, 224, 224, 1); /// text on card or block
  Color get darkOnPrimary => white; /// text on theme mode
  Color get darkOnSecondary => white; /// text on theme mode
  Color get darkError => const Color.fromARGB(255, 195, 7, 1); /// warning, error, failed
  Color get darkOnError => darkOnPrimary; /// text on warning, error, failed

  /// BASE
  Color get black => const Color.fromRGBO(0, 0, 0, 1);
  Color get white => const Color.fromRGBO(255, 255, 255, 1);

}
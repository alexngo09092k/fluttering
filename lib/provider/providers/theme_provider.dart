import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttering/utils/index.dart';
import 'package:intl/intl.dart';

import '../../provider/provider.dart';
import '../../provider/provider_delegate.dart';

abstract class IThemeProvider extends Provider with ProviderDelegate {
  ThemeMode get themeMode;

  Brightness get brightness;

  Locale get currentLocale;

  NumberFormat get format;

  void onChangePlatformBrightness();

  void changeThemeMode(ThemeMode themeMode);

  Locale? onChangeLocale(Locale? locale, Iterable<Locale> supportedLocales);

  bool get useSystem;

  static Color colorByTheme({required Color light, required Color dark}) {
    throw ErrorDescription("Not found Theme Provider");
  }
}

class ThemeProvider extends IThemeProvider {
  @override
  String get version => "v0.0.1";

  /// sh1 theme_mode
  String get _themeModeKey => 'fluttering_theme_mode';

  static final IThemeProvider _instance = ThemeProvider._internal();
  static IThemeProvider get instance => _instance;

  factory ThemeProvider() => _instance as ThemeProvider;

  ThemeProvider._internal();

  ThemeMode _themeMode = ThemeMode.light;

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  Brightness get brightness => _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;

  Locale _currentLocale = const Locale('en');

  @override
  Locale get currentLocale => _currentLocale;

  @override
  NumberFormat get format => NumberFormat.simpleCurrency(locale: _currentLocale.toString());

  bool _useSystem = true;

  @override
  bool get useSystem => _useSystem;

  static Color colorByTheme({required Color light, required Color dark}) {
    return _instance.themeMode == ThemeMode.light ? light : dark;
  }

  @override
  void onChangePlatformBrightness() {
    if (!_useSystem) return;
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    Debug.log("============ THEME MODE FROM SYSTEM $themeMode ============");
    setStatusBarByTheme(_themeMode);
    notifyListeners();
  }

  @override
  void changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    _useSystem = false;
    AsyncStorage.instance.setString(_themeModeKey, _themeMode.name);
    setStatusBarByTheme(_themeMode);
    notifyListeners();
  }

  @override
  Locale? onChangeLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return _currentLocale;

    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
        _currentLocale = supportedLocale;
        return _currentLocale;
      }
    }
    _currentLocale = supportedLocales.firstWhere((supportedLocale) => supportedLocale.languageCode == 'en');

    return _currentLocale;
  }

  void syncFromStorage([bool notify = false]) {
    clean();

    String? themeMode = AsyncStorage.instance.getString(_themeModeKey);
    Debug.log("============ THEME MODE FROM ASYNCE STORAGE $themeMode ============");

    if (themeMode == null) return;

    _useSystem = false;
    if (themeMode == ThemeMode.dark.name) {
      _themeMode = ThemeMode.dark;
    } else if (themeMode == ThemeMode.light.name) {
      _themeMode = ThemeMode.light;
    }

    setStatusBarByTheme(_themeMode);

    if (notify) notifyListeners();
  }

  @override
  Future<bool> registered() async {
    syncFromStorage();
    return true;
  }

  void clean([bool notify = false]) {
    _useSystem = false;

    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    setStatusBarByTheme(_themeMode);

    if (notify) notifyListeners();
  }

  void setStatusBarByTheme(
    ThemeMode themeMode, {
    Color? systemNavigationBarColor,
    Color? systemNavigationBarDividerColor,
    bool? systemNavigationBarContrastEnforced,
    Color? statusBarColor,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
    bool? systemStatusBarContrastEnforced,
    Brightness? systemNavigationBarIconBrightness,
  }) {
    switch (themeMode) {
      case ThemeMode.dark:
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
            systemNavigationBarContrastEnforced: systemNavigationBarContrastEnforced,
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarIconBrightness,
            statusBarBrightness: statusBarBrightness,
            systemStatusBarContrastEnforced: systemStatusBarContrastEnforced,
            systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
          ),
        );
        break;
      case ThemeMode.light:
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
            systemNavigationBarContrastEnforced: systemNavigationBarContrastEnforced,
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarIconBrightness,
            statusBarBrightness: statusBarBrightness,
            systemStatusBarContrastEnforced: systemStatusBarContrastEnforced,
            systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
          ),
        );
        break;
      default:
    }
  }
}

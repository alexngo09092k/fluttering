import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttering/utils/index.dart';

import '../../provider/provider.dart';
import '../../provider/provider_delegate.dart';
abstract class IThemeProvider extends Provider with ProviderDelegate {
  ThemeMode get themeMode;

  Brightness get brightness;

  Locale get currentLocale;

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
  String get _themeModeKey => 'ed3931f52bc9022d761c5325f624e9264158498b';

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
    _currentLocale = supportedLocales.firstWhere(
      (supportedLocale) => supportedLocale.languageCode == 'en',
    );

    return _currentLocale;
  }

  void syncFromStorage([bool notify = false]) {
    clean();

    String? themeMode = AsyncStorage.instance.getString(_themeModeKey);
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
    _themeMode = ThemeMode.dark;
    setStatusBarByTheme(_themeMode);

    if (notify) notifyListeners();
  }
}

extension StatusBarThemeProviderEx on ThemeProvider {
  void setStatusBarByTheme(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        setLightStatusBar();
        break;
      case ThemeMode.light:
        setDarkStatusBar();
        break;
      default:
    }
  }

  /// Changes the text and icon color on the statusbar to a dark color
  void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(getDarkStatusBar());
  }

  /// Changes the text and icon color on the statusbar to a light color
  void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(getLightStatusBar());
  }

  SystemUiOverlayStyle getLightStatusBar() => const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      );

  SystemUiOverlayStyle getDarkStatusBar() => const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      );
}

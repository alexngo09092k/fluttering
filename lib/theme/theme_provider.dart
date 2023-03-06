import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../provider/provider.dart';
import '../provider/provider_delegate.dart';
import '../modules/index.dart';

abstract class IThemeProvider extends Provider with ProviderDelegate {
  ThemeMode get themeMode;

  Brightness get brightness;

  Locale get locale;

  NumberFormat get format;

  void onChangePlatformBrightness();

  void changeThemeMode(ThemeMode themeMode);

  Locale? onChangeLocale(Locale? locale, Iterable<Locale> supportedLocales);

  void changeLocale(Locale locale);

  void setStatusBarByTheme({
    Color? systemNavigationBarColor = Colors.white,
    Color? systemNavigationBarDividerColor,
    bool? systemNavigationBarContrastEnforced,
    Color statusBarColor = Colors.transparent,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
    bool? systemStatusBarContrastEnforced,
    Brightness? systemNavigationBarIconBrightness,
  });
}

class ThemeProvider extends IThemeProvider {
  @override
  String get version => "v0.0.1";

  ThemeProvider({ThemeMode themeMode = ThemeMode.light, Locale locale = const Locale('en')}) {
    _themeMode = themeMode;
    AsyncStorage.instance.setString(_themeModeKey, _themeMode.name);

    _locale = locale;
    AsyncStorage.instance.setString(_localeKey, _locale.languageCode);
  }

  String get _themeModeKey => 'fluttering_theme_mode';

  late ThemeMode _themeMode;
  @override
  ThemeMode get themeMode => _themeMode;

  @override
  Brightness get brightness => _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;

  String get _localeKey => 'fluttering_locale';

  late Locale _locale;
  @override
  Locale get locale => _locale;

  @override
  NumberFormat get format => NumberFormat.simpleCurrency(locale: _locale.toString());

  @override
  void onChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    ThemeMode themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    if (themeMode != _themeMode) {
      _themeMode = themeMode;
      AsyncStorage.instance.setString(_themeModeKey, _themeMode.name);
      setStatusBarByTheme();
      notifyListeners();
    }
  }

  @override
  void changeThemeMode(ThemeMode themeMode) {
    if (themeMode != _themeMode) {
      _themeMode = themeMode;
      AsyncStorage.instance.setString(_themeModeKey, _themeMode.name);
      setStatusBarByTheme();
      notifyListeners();
    }
  }

  @override
  Locale? onChangeLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return _locale;

    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
        _locale = supportedLocale;
        return _locale;
      }
    }

    _locale = supportedLocales.firstWhere((supportedLocale) => supportedLocale.languageCode == 'en');
    AsyncStorage.instance.setString(_localeKey, _locale.languageCode);

    return _locale;
  }

  @override
  void changeLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      AsyncStorage.instance.setString(_localeKey, _locale.languageCode);
    }
  }

  void syncFromStorage([bool notify = false]) {
    String? themeMode = AsyncStorage.instance.getString(_themeModeKey);
    if (themeMode == ThemeMode.dark.name) {
      _themeMode = ThemeMode.dark;
    } else if (themeMode == ThemeMode.light.name) {
      _themeMode = ThemeMode.light;
    }

    String? languageCode = AsyncStorage.instance.getString(_localeKey);
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }

    setStatusBarByTheme();

    if (notify) notifyListeners();
  }

  @override
  Future<bool> registered() async {
    syncFromStorage(true);
    return true;
  }

  @override
  void setStatusBarByTheme({
    Color? systemNavigationBarColor = Colors.white,
    Color? systemNavigationBarDividerColor,
    bool? systemNavigationBarContrastEnforced,
    Color statusBarColor = Colors.transparent,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
    bool? systemStatusBarContrastEnforced,
    Brightness? systemNavigationBarIconBrightness,
  }) {
    switch (_themeMode) {
      case ThemeMode.light:
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
      case ThemeMode.dark:
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

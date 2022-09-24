/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

abstract class LCProvider {
  /// is called when provider is registed
  Future<bool> onRegisted();

  /// is called before go to splash screen
  Future<bool> willSplash();

  /// is called when went to splash screen
  Future<bool> didSplash();

  /// is called when closed app
  Future<bool> willCloseApp();
}

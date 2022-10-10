/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:fluttering/provider/provider.dart';

abstract class IFlutteringProviderDelegate extends FlutteringProvider {
  /// is called when provider is registed
  Future<bool> onRegisted();

  /// is called when open app
  Future<bool> willOpenApp();

  /// is called when closed app
  Future<bool> willCloseApp();

  /// is called when splash screen is opend
  Future<bool> willSplash();
}

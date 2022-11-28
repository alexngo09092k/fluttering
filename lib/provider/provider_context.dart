import 'package:flutter/material.dart';

import '../widgets/app_state.dart';

abstract class ProviderContext {
  BuildContext? get context => AwesomeAppState.navigatorKey.currentContext;
  Size get screen => AwesomeAppState.screen;
}

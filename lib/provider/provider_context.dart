import 'package:flutter/material.dart';

import '../app/app_state.dart';

abstract class ProviderContext {
  BuildContext? get context => AwesomeAppState.navigatorKey?.currentContext;
}

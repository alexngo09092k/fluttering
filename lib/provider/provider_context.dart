import 'package:flutter/material.dart';
import 'package:fluttering/widgets/app_state.dart';

abstract class FlutteringProviderContext {
  BuildContext? get context => FlutteringAppState.navigatorKey?.currentContext;
}

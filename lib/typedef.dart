import 'package:flutter/material.dart';
import 'package:fluttering/fluttering_app.dart';
import 'package:fluttering/provider/typedef.dart';

export 'package:fluttering/provider/typedef.dart';
export 'package:fluttering/classes/typedef.dart';

typedef AppState<T extends StatefulWidget> = FlutteringAppState<T>;
typedef SplashState<T extends StatefulWidget> = FlutteringSplashState<T>;
typedef ProviderState<T extends StatefulWidget, R extends IProvider> = FlutteringProviderState<T, R>;

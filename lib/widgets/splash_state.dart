/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import '../provider/index.dart';

abstract class AwesomeSplashState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    ManagerProvider.willSplash().then((_) => onSplash(_));
    super.initState();
  }

  void onSplash(bool resultOnWillSplash);

  @override
  void dispose() {
    super.dispose();
  }
}

/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'package:flutter/material.dart';
import 'package:fluttering/provider/provider_context.dart';
import 'package:fluttering/provider/provider_delegate.dart';
import 'package:fluttering/provider/manager_provider.dart';
import 'package:fluttering/provider/provider.dart';
import 'package:fluttering/provider/provider_observer.dart';
import 'package:fluttering/provider/widgets/autoplistener.dart';
import 'package:fluttering/provider/widgets/autopplistener.dart';
import 'package:fluttering/provider/widgets/plistener.dart';
import 'package:fluttering/provider/widgets/pplistener.dart';
import 'package:fluttering/provider/widgets/pstate.dart';

typedef LazyProviderCallback<T extends IProvider> = LazyFlutteringCallback<T>;

typedef ManagerProvider = FlutteringManagerProvider;

typedef IProvider = IFlutteringProvider;

typedef ProviderDelegate = FlutteringProviderDelegate;

typedef ProviderObserver = FlutteringProviderObserver;

typedef ProviderContext = FlutteringProviderContext;

typedef Provider = FlutteringProvider;

typedef BaseConsumer<T extends IProvider> = FlutteringProviderListener<T>;

typedef BasePropConsumer<T extends IProvider, R> = FlutteringPropProviderListener<T, R>;

typedef Consumer<T extends IProvider> = AutoFlutteringProviderListener<T>;

typedef PropConsumer<T extends IProvider, R> = AutoPFlutteringProviderListener<T, R>;

typedef ProviderState<T extends StatefulWidget, R extends IProvider> = FlutteringProviderState<T, R>;
typedef ProviderStateObserver<T extends StatefulWidget, R extends IProvider> = FlutteringProviderStateObserver<T, R>;


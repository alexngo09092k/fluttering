import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';

void main() {
  AwesomeApp(app: const MyApp(), providers: [ThemeProvider()]).run();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends AwesomeAppState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text(
            "This is a example for use fluttering",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

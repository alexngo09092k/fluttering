import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';

void main() {
  AwesomeApp(
    app: const ExampleApp(),
    providers: [
      ThemeProvider(themeMode: ThemeMode.system),
    ],
    onWillInitialize: () async {
      Debug.log('onWillInitialize');
      return true;
    },
    onDidInitialize: () async {
      Debug.log('onDidInitialize');
      return true;
    },
    onError: (error) {
      Debug.log('Error: $error');
    },
    debugMode: kDebugMode,
    inAppReview: const InAppReviewConfig(enable: false),
  ).run();
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends AwesomeAppState<ExampleApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, child, theme) {
        return MaterialApp(
          navigatorKey: AwesomeAppState.navigatorKey,
          title: 'Fluttering Example',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: theme.themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, child, theme) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Fluttering Demo'),
            actions: [
              IconButton(
                icon: Icon(
                  theme.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  theme.changeThemeMode(
                    theme.themeMode == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark,
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to fluttering!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Theme: ${theme.themeMode.name}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final hasNet =
                        await InternetConnection.instance.checkConnection();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            hasNet ? 'Connected to internet' : 'No internet',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Check Connectivity'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await DeviceInfo.instance.initial();
                    final info = DeviceInfo.instance.info;
                    Debug.log(info);
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Device Info'),
                          content: SingleChildScrollView(
                            child: Text(info?.toString() ?? 'N/A'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Show Device Info'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vaahflutter/vaahflutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VaahEnv.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaahFlutter',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VaahFlutter')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Version: ${VaahEnv.instance.data.appVersion} (${VaahEnv.instance.data.buildNumber})',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

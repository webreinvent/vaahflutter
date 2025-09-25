import 'package:flutter/material.dart';
import 'package:vaahflutter/vaahflutter.dart';
import 'package:vaahflutterexample/models/user.dart';
import 'package:vaahflutterexample/widgets/notificiation_permission_section.dart';
import 'package:vaahflutterexample/widgets/push_notification_section.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VaahEnv.init();
  await VaahLogger().wrapAppRunner(appRunner: () => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaahFlutter',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = VaahLogger();
    final user = User(id: 'abc123', name: 'John Doe');
    return Scaffold(
      appBar: AppBar(title: const Text('VaahFlutter')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.bindUser(user);
                      },
                      child: const Text('Bind User'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.unbindUser();
                      },
                      child: const Text('Unbind User'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.info('Clicked Info', {'button': 'info'});
                      },
                      child: const Text('Log Info'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.warn('Clicked Warn', {'button': 'warn'});
                      },
                      child: const Text('Log Warn'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.error(
                          'Clicked Error with exception',
                          error: Exception('Simulated handled exception'),
                          stackTrace: StackTrace.current,
                          context: {'button': 'error'},
                        );
                      },
                      child: const Text('Log Error'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.fatal(
                          'Clicked Fatal with exception',
                          error: Exception('Simulated handled exception'),
                          stackTrace: StackTrace.current,
                          context: {'button': 'fatal'},
                        );
                      },
                      child: const Text('Log Fatal'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Future.microtask(() => throw StateError('Uncaught test error'));
                      },
                      child: const Text('Throw uncaught exception'),
                    ),
                  ),
                ],
              ),
              const NotificationPermissionSection(),
              const PushNotificationSection(),
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

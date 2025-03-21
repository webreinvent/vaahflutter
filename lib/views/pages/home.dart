import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../vaahextendflutter/services/notification/internal/notification_view.dart';
import 'ui/index.dart';

class HomePage extends StatefulWidget {
  static const String routePath = '/home';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routePath),
      builder: (_) => const HomePage(),
    );
  }

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const MethodChannel _platform = MethodChannel('snackbar_channel');

  /// Calls the native platform method to show a snackbar.
  Future<void> _showNativeSnackbar() async {
    try {
      final String? result = await _platform.invokeMethod<String>('showSnackbar');
      if (result != null) {
        debugPrint("Native Snackbar Response: $result");
      } else {
        debugPrint("Native Snackbar returned null response");
      }
    } on PlatformException catch (e, stackTrace) {
      debugPrint("Failed to show snackbar: ${e.message}, Code: ${e.code}");
      debugPrint(stackTrace.toString());
    } on MissingPluginException {
      debugPrint("MethodChannel 'showSnackbar' not implemented on this platform.");
    } catch (e, stackTrace) {
      debugPrint("Unexpected error while showing snackbar: $e");
      debugPrint(stackTrace.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: increaseOpenCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showNativeSnackbar,
        child: const Icon(Icons.message),
      ),
      appBar: AppBar(
        actions: const [
          InternalNotificationsBadge(),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, UIPage.route());
          },
          child: const Text('WebReinvent'),
        ),
      ),
    );
  }
}

# Environment (VaahEnv)

This package ships with a tiny Environment helper that exposes runtime app metadata in a single place and makes it available across your app.

Current fields exposed via `VaahEnvData`:

- `appName`
- `packageName`
- `appVersion`
- `buildNumber`
- `vars` (Map<String, dynamic>) — key/value map loaded from a JSON asset, selected at build/run time

You can extend this to include your own typed config later (e.g., API base URL, feature flags, flavors, etc.).

## 1) Installation prerequisites

The package already depends on `package_info_plus`, which powers the runtime values. You only need to:

- Run `flutter pub get` after adding/updating this package in your app.

No extra native setup is required for most projects.

## 2) Initialize early (before runApp)

Initialize the environment exactly once during app boot.

```dart
import 'package:flutter/widgets.dart';
import 'package:vaahflutter/vaahflutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Populate VaahEnv.instance.data with runtime app info
  await VaahEnv.init();

  runApp(const MyApp());
}
```

If you access `VaahEnv.instance.data` before calling `VaahEnv.init()`, an exception will be thrown: `VaahEnv has not been initialized`.

### 2a) Pick environment via --dart-define (JSON asset)

VaahEnv loads a JSON file from your bundled assets based on a compile-time define `ENV_CONFIG`.

1. Create JSON files under `assets/env/` (examples):

```
assets/
  env/
    dev.json
    staging.json
    prod.json
```

2. Ensure they are declared in your app's `pubspec.yaml` (either the folder or explicit files):

```yaml
flutter:
  assets:
    - assets/env/
    # or
    # - assets/env/dev.json
    # - assets/env/staging.json
    # - assets/env/prod.json
```

3. Provide the file name via `--dart-define=ENV_CONFIG` when you run/build:

```bash
# Development
flutter run --dart-define=ENV_CONFIG=dev.json

# Staging
flutter run --dart-define=ENV_CONFIG=staging.json

# Production builds
flutter build apk  --dart-define=ENV_CONFIG=prod.json
flutter build ios  --dart-define=ENV_CONFIG=prod.json
flutter build web  --dart-define=ENV_CONFIG=prod.json
```

4. JSON format example:

```json
{
  "API_BASE_URL": "https://api.dev.example.com",
  "ENABLE_LOGS": true,
  "PUBLISHABLE_KEY": "pk_test_abc123",
  "MERCHANT_ID": "com.example.merchant"
}
```

5. Read values anywhere:

```dart
final vars = VaahEnv.instance.data.vars;
final baseUrl = vars['API_BASE_URL'] as String;
final enableLogs = vars['ENABLE_LOGS'] as bool? ?? false;
```

Notes:

- Always provide `ENV_CONFIG`; the current default is an empty string, which will cause the loader to look for `assets/env/` (invalid) and throw.
- Asset loading relies on Flutter's `rootBundle`. Ensure the asset paths match your `pubspec.yaml` and run `flutter pub get` after changes.
- JSON is recommended for web, iOS, Android, macOS, Windows, and Linux because it is supported uniformly by Flutter assets.

## 3) Read values anywhere

Use the singleton to access the computed values after initialization.

```dart
import 'package:vaahflutter/vaahflutter.dart';

void logEnv() {
  final env = VaahEnv.instance.data;
  // Example usage
  // print('App: ${env.appName} v${env.appVersion} (${env.buildNumber})');
}
```

Example in a widget:

```dart
import 'package:flutter/material.dart';
import 'package:vaahflutter/vaahflutter.dart';

class EnvBanner extends StatelessWidget {
  const EnvBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final env = VaahEnv.instance.data;

    return Text(
      '${env.appName} v${env.appVersion} (${env.buildNumber})',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
```

## 4) Troubleshooting

- Error: `VaahEnv has not been initialized`

  - Ensure you call `WidgetsFlutterBinding.ensureInitialized();` and then `await VaahEnv.init();` in `main()` before `runApp()`.

- Asset not found or JSON decode error

  - Verify `--dart-define=ENV_CONFIG=<fileName>` points to an existing file under `assets/env/`.
  - Confirm your `pubspec.yaml` includes `assets/env/` and re-run `flutter pub get`.
  - Check for trailing commas or invalid JSON.

- Wrong environment selected
  - Print the active file at boot to confirm: `print(const String.fromEnvironment('ENV_CONFIG'));`
  - Double-check your IDE's run configuration or CI build flags.

## 5) Extending the Environment (optional)

You can enrich `VaahEnvData` with project‑specific config such as API base URL, feature flags, flavor, etc. A typical approach is to:

- Add fields to `VaahEnvData`.
- Populate those fields inside `VaahEnv.init()` from:
  - compile‑time values via `--dart-define`, or
  - flavor files, or
  - local JSON/config.

Example sketch (illustration only):

```dart
// 1) Add fields
class VaahEnvData {
  const VaahEnvData({
    required this.appName,
    required this.packageName,
    required this.appVersion,
    required this.buildNumber,
    required this.vars,
    // new fields
    this.apiBaseUrl,
    this.enableLogs = false,
  });

  final String appName;
  final String packageName;
  final String appVersion;
  final String buildNumber;
  final Map<String, dynamic> vars;

  // optional custom fields
  final String? apiBaseUrl;
  final bool enableLogs;
}

// 2) Populate in VaahEnv.init() from JSON vars
static Future<void> init() async {
  final info = await PackageInfo.fromPlatform();
  const String env = String.fromEnvironment('ENV_CONFIG', defaultValue: '');
  final vars = jsonDecode(await rootBundle.loadString('assets/env/$env'));

  instance._data = VaahEnvData(
    appName: info.appName,
    packageName: info.packageName,
    appVersion: info.version,
    buildNumber: info.buildNumber,
    vars: vars,
    apiBaseUrl: vars['API_BASE_URL'] as String?,
    enableLogs: (vars['ENABLE_LOGS'] as bool?) ?? false,
  );
}
```

Then select the environment file with `--dart-define=ENV_CONFIG=<fileName>.json` as shown above. If you prefer compile‑time values for some fields, you can still use `const String.fromEnvironment(...)` to override or complement values from JSON.

This keeps your runtime configuration centralized and typed.

## 6) Notes for testing

If you need to read `VaahEnv.instance.data` in tests, ensure you initialize it first in your test bootstrap (e.g., call `WidgetsFlutterBinding.ensureInitialized();` and `await VaahEnv.init();`). If you later add custom fields that depend on platform channels, consider adding a helper in your code (e.g., `VaahEnv.bootstrap(VaahEnvData data)`) to inject test data without hitting platform APIs.

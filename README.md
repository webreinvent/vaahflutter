# [VaahFlutter by WebReinvent](https://docs.vaah.dev/vaahflutter)

VaahFlutter is a Flutter-based framework that provides common features required in any application.

The purpose of developing VaahFlutter is to create a framework that can be extended in a manageable and structured manner in order to develop large applications while not having to reinvent all essential functionalities every time.

For More Info Please Check: [docs.vaah.dev/vaahflutter](https://docs.vaah.dev/vaahflutter)

## Prerequisites

Project requires Dart and flutter versions:

```yaml
  sdk: ">=2.19.2"
  flutter: ">=3.7.3"
```

To change minimum requirement of dart and flutter change the `sdk and flutter` versions under `environment` in the `pubspec.yaml` file.
<hr />

## How to run app in different environments:

| **Environment name** | **Command** |
| --- | --- |
| Default | `flutter run` OR `flutter run --dart-define="environment=default"`  |
| Development | `flutter run --dart-define="environment=develop"` |
| Staging/ QA | `flutter run --dart-define="environment=stage"` |
| Production | `flutter run --dart-define="environment=production"` |

## How to build app?

### Building app with different environments

| **Platform** | **Environment name** | **Command** |
| --- | --- | --- |
| Android | Default | `flutter build apk` OR `flutter build apk --dart-define="environment=default"`  |
| Android | Development | `flutter build apk --dart-define="environment=develop"` |
| Android | Staging/ QA | `flutter build apk --dart-define="environment=stage"` |
| Android | Production | `flutter build apk --dart-define="environment=production"` |
| Android (appbundle) | Default | `flutter build appbundle` OR `flutter build appbundle --dart-define="environment=default"`  |
| Android (appbundle) | Development | `flutter build appbundle --dart-define="environment=develop"` |
| Android (appbundle) | Staging/ QA | `flutter build appbundle --dart-define="environment=stage"` |
| Android (appbundle) | Production | `flutter build appbundle --dart-define="environment=production"` |

| **Platform** | **Environment name** | **Command** |
| --- | --- | --- |
| iOS | Default | `flutter build ipa` OR `flutter build ipa --dart-define="environment=default"`  |
| iOS | Development | `flutter build ipa --dart-define="environment=develop"` |
| iOS | Staging/ QA | `flutter build ipa --dart-define="environment=stage"` |
| iOS | Production | `flutter build ipa --dart-define="environment=production"` |
| iOS (.app) | Default | `flutter build ios` OR `flutter build ipa --dart-define="environment=default"`  |
| iOS (.app) | Development | `flutter build ios --dart-define="environment=develop"` |
| iOS (.app) | Staging/ QA | `flutter build ios --dart-define="environment=stage"` |
| iOS (.app) | Production | `flutter build ios --dart-define="environment=production"` |

### Building in different modes.

Pass additional arguments with your build commands.

| **mode** | **Command** |
| --- | --- |
| Debug | `flutter build ipa --debug`, `flutter build apk --debug`  |
| Profile | `flutter build ipa --profile`, `flutter build apk --profile`  |
| Release | `flutter build ipa --release`, `flutter build apk --release`  |

### Building ipa without signing it
| **flag** | **command** |
| --- | --- |
| --no-codesign | `flutter build ipa --no-codesign`, `flutter build ios --no-codesign`  |

Note: building for `ipa` will give `Runner.xcarchive`. To check the app, you should right click on `Runner.xcarchive` > then select `show package contents` > then open `products` > `application` > There you will be able to find the application.

## Packages:
In `pubspec.yaml` file > Add essential packages in `dependencies`, and packages that a developer need in `dev_dependencies`.

To automatically upgrade your package dependencies to the latest versions consider running
```
flutter pub upgrade --major-versions
```

To see which dependencies have newer versions available, run
```
flutter pub outdated
```
<hr />

## Project structure and coding conventions:

### [Official dart conventions](https://dart.dev/guides/language/effective-dart/style)

- 2 spaces for indentation
- test files have `_test.ext` suffix in the file name > example `widget_test.dart`
- Libraries, packages, directories, and source files name convention: snake_case(lowercase_with_underscores).
- Classes, Enums, Typedefs, and extensions naming convention: UpperCamelCase.
- Variables, constants, parameters naming convention: lowerCamelCase.
- Method/ functions naming convention: lowerCamelCase.
- Use relative path
  - ✘ `import 'package:demo/home.dart';` → This should be avoided.
  - ✔ `import './home.dart';` → Correct way
  - to fix imports you can use [dart-import](https://marketplace.visualstudio.com/items?itemName=luanpotter.dart-import)
- Avoid using as instead, use is operator
- Avoid print()/ debugPrint() calls

Android Production
- universal package: `com.webreinvent.vaahflutter`

iOS Production
- universal package: `com.webreinvent.vaahflutter`
# Team Mobile App by WebReinvent

## Prerequisites

Dart and flutter versions: the project requires
``` 
  dart sdk >=2.18.2
  and flutter version >=3.3.4
```

To change minimum requirement of dart and flutter change the `sdk and flutter` versions under `environment` in the `pubspec.yaml` file.
<hr />

## Setup

Run the command: 
```
flutter pub get
```

## Environments

### To run app in `production` mode use command
```
flutter run --dart-define="environment=production"
```

### To run app in `staging/ QA` mode use command 
```
flutter run --dart-define="environment=stage"
```

### To run app in `develop` mode use command 
```
flutter run --dart-define="environment=develop"
```

### For Android production build use command
```
flutter build apk --dart-define="environment=production"
```

### For iOS production build use command
```
flutter build ipa --dart-define="environment=production"
```

### How to create a new environment:

Go to `lib/env.dart`, find `envConfigs` variable and add configuration for the environment you want to create. Example: for `testing` environment add `'testing'` key and value. And in commands pass your environment name
```
// for example if environment name is testing then
flutter run --dart-define="environment=testing"
```
<hr />

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
- universal package: `com.webreinvent.team`

iOS Production
- universal package: `com.webreinvent.team`

## VaahExtendedFlutter

### Central log library:

Can be used for logging different details. All methods are static thus no instance of Console is required. Console.info() method will print info in blue color font, Console.success() method will print log in green color font, Console.warning() method will print log in yellow color font, and Console.danger() method will print log in red color font. The files reside in `lib/vaahextendflutter/log/` folder.

### Environment and Version Tag

Environment and Version Tag can be seen on every page unless you set `showEnvAndVersionTag` for your Environment configuration in `env.dart` file. You can change color of tag by setting `envAndVersionTagColor` variable for your Environment configuration. 

NOTE: `Remember showEnvAndVersionTag for production should always be false in Environment configuration in `env.dart` file.`
```dart
  'production': defaultConfig.copyWith(
    ...
    showEnvAndVersionTag: false,
  ),
```

NOTE: Whenever you create a new screen/ page, wrap the body with `TagWrapper` class.

You can use alignment and margin properties for achieving desired results using TagWrapper.
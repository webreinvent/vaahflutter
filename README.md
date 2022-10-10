# Team Mobile App by WebReinvent

## Prerequisites

Dart and flutter versions: the project requires
``` 
  dart sdk >=2.18.2
  and flutter version >=3.3.4
```

to change minimum requirement of dart and flutter change the `sdk and flutter` versions under `environment` in the `pubspec.yaml` file.
<hr />

## Setup

run the command: 
```
flutter pub get
```

- Environments

  - The app can be run in three different environments - Production, Staging/ QA, and Development.

  - To run app in `production` mode use command 
  ```
  flutter run --dart-define=environment='production'
  ```

  - To run app in `staging/ QA` mode use command 
  ```
  flutter run --dart-define=environment='staging'
  ```

  - To run app in `development` mode use command 
  ```
  flutter run --dart-define=environment='development'
  ```

  - For Android production build use command
  ```
  flutter build apk --dart-define=environment='production'
  ```

  - For iOS production build use command
  ```
  flutter build ipa --dart-define=environment='production'
  ```

To change environment configuration change constants in `lib/env.dart` file.
Environment module is made of 2 files, 
```
lib/env.dart,
lib/vaahextendflutter/environment/env_helpers.dart.
```
<hr />

## Packages:
In `pubspec.yaml` file > Add essential packages in dependencies, and packages that a developer need in dev_dependencies.

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
- Classes, enums, typedefs, and extensions naming conevntion: UpperCamelCase.
- Variables, constants, parameters naming convention: lowerCamelCase.
- Method/ functions naming conevntion: lowerCamelCase.
- Use relative path
  - ✘ `import 'package:demo/home.dart';` -> This should be avoided.
  - ✔ `import './home.dart';` -> Correct way
  - to fix imports you can use [dart-import](https://marketplace.visualstudio.com/items?itemName=luanpotter.dart-import)
- Avoid using as instead, use is operator
- Avoid print()/ debugPrint() calls

Android Production
- universal package: `com.webreinvent.team`

iOS Production
- universal package: `com.webreinvent.team`
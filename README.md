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
- universal package: `com.webreinvent.team`

iOS Production
- universal package: `com.webreinvent.team`

## VaahExtendFlutter

### → Central log library:

Can be used for logging different details. All methods are static thus no instance of Console is required. Console.info() method will print info in blue color font, Console.success() method will print log in green color font, Console.warning() method will print log in yellow color font, and Console.danger() method will print log in red color font. The files reside in `lib/vaahextendflutter/log/` folder.

### → Environment and Version Tag Panel

Environment and Version Tag can be seen on every page unless you set `showEnvAndVersionTag` to `false` for your Environment configuration in `env.dart` file. You can change color of tag by setting `envAndVersionTagColor` variable for your Environment configuration. 

NOTE: `Remember showEnvAndVersionTag for production should always be false in Environment configuration in `env.dart` file.`
```dart
  'production': defaultConfig.copyWith(
    ...
    showEnvAndVersionTag: false,
  ),
```

#### NOTE: You have to write below code in MaterialApp, and that will show tag panel on each screen. You don't have to wrap any other screen/ widget, or you don't have to extend any screen/ any widget with TagPanelHost.

In file containing material app paste this code after imports
```dart
final _navigatorKey = GlobalKey<NavigatorState>();
```
 In material app paste this code and panel will be visible on all pages.
```dart
builder: (BuildContext context, Widget? child) {
  return TagPanelHost(
    navigatorKey: _navigatorKey,
    child: child!,
  );
},
```
This panel uses EnvController, thus depends on env.dart file.

### → Dynamic font size, dynamic width, dynamic height depending on device size

To use it directly by importing `screen_util.dart` check Usage: comment in `screen_util.dart` file. 

Or for feasibility extend your Statelesswidgets with BaseStateless
```dart
class DemoPage extends BaseStateful {
}
```

And Statefull widgets with BaseStateful widgets
```dart
class _DemoPageState extends BaseStateful<DemoPage> {
...
}
```
After that you can use dynamic size in that extended widget.
```dart
SizedBox(
  width: 300.wExt, // or swExt
  height: 200.hExt, // or shExt
  child: Text(
    'demo',
    style: TextStyle(
      fontSize: 20.spExt,
    ),
  ),
);
```

### → Base widgets
`vaahextendflutter/base` folder contains all the base classes/ widgets.

BaseStateless and BaseStateful are used when dev wants to init/ add dependencies in many screens and don't want to write same logic in every file, so they write the logic in base files only. e.g. internet connectivity checker, dynamic size dependency, etc.

So base class implements those logics and other classes can extend the base classes.

### → Helpers
Most common constants and styles used in whole app.


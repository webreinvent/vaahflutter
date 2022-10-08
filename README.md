# Team Mobile App by Webreinvent

## Prerequisites

Dart and flutter versions: the project requires
``` 
  dart sdk >=2.18.2
  and flutter version >=3.3.4
```

to change minimum requirement of dart and flutter change the `sdk and flutter` versions under `environment` in the `pubspec.yaml` file.
<hr />

## Setup

run the command: `flutter pub get`
<hr />

### Packages:
In pubspec.yaml file > Add essential packages in dependencies, and packages that a developer need in dev_dependencies.

To automatically upgrade your package dependencies to the latest versions consider running `flutter pub upgrade --major-versions`. To see which dependencies have newer versions available, run `flutter pub outdated`
<hr />

### Project structure:
- 2 spaces for indentation
- test files have `_test.ext` suffix in the file name > example `widget_test.dart`

Android Production
- universal package: `com.webreinvent.team`

iOS Production
- universal package: `com.webreinvent.team`
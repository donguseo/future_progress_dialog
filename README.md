# future_progress_dialog

FutureProgressDialog start with showDialog function, but dismiss automatically when futre task is finished. 

## Supported Dart Versions
**Dart SDK version >= 2.1.0**

## Installation
Add the Package
```yaml
dependencies:
  future_progress_dialog: ^0.0.2
```

## How to use

Import the package in your dart file

```dart
import 'package:future_progress_dialog/future_progress_dialog.dart';
```

Call showDialog method with FutureProgressDialog.
```dart
showDialog(context, FutureProgressDialog(future, 'loading...'));
```

# future_progress_dialog

future_progress_dialog is a simple progress dialog library for async tasks.
FutureProgressDialog start when you call showDialog function, but dismiss automatically when future task is finished. 

## Supported Dart Versions
**Dart SDK version >= 2.1.0**

## Installation
Add the Package
```yaml
dependencies:
  future_progress_dialog: ^0.2.0
```

## How to use

Import the package in your dart file

```dart
import 'package:future_progress_dialog/future_progress_dialog.dart';
```

Call showDialog method with FutureProgressDialog with message.
```dart
    showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: Text('Loading...')),
    );
```

<img src="https://github.com/donguseo/future_progress_dialog/blob/master/readme_res/future_progress_dialog.png?raw=true" width=200 />

Or you can show it without message.
```dart
    await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture()),
    );
```

<img src="https://github.com/donguseo/future_progress_dialog/blob/master/readme_res/future_progress_dialog_without_msg.png?raw=true" width=200 />


import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {
  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Future Progress Dialog'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  showProgress(context);
                },
                child: Text('Show Progress Dialog'),
              ),
              ElevatedButton(
                onPressed: () {
                  showProgressWithoutMsg(context);
                },
                child: Text('Show Progress Dialog Without Message'),
              ),
              ElevatedButton(
                onPressed: () {
                  showProgressWithCustomProgress(context);
                },
                child: Text('Show Progress Dialog with custom progress'),
              )
            ],
          ),
        ));
  }

  Future<void> showProgress(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: Text('Loading...')),
    );
    showResultDialog(context, result);
  }

  Future<void> showProgressWithoutMsg(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(getFuture()));
    showResultDialog(context, result);
  }

  Future<void> showProgressWithCustomProgress(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
              getFuture(),
              progress: _CustomProgress(),
            ));

    showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(result),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }
}

class _CustomProgress extends StatefulWidget {
  const _CustomProgress({
    Key key,
  }) : super(key: key);

  @override
  __CustomProgressState createState() => __CustomProgressState();
}

class __CustomProgressState extends State<_CustomProgress>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        value: 0.0, duration: Duration(milliseconds: 1000), vsync: this);
    controller.repeat();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedIcon(
        icon: AnimatedIcons.add_event,
        progress: controller,
      ),
    );
  }
}

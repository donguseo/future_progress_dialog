import 'package:flutter/material.dart';
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
              RaisedButton(
                onPressed: () {
                  showProgress(context);
                },
                child: Text('Show Progress Dialog'),
              ),
              RaisedButton(
                onPressed: () {
                  showProgressWithoutMsg(context);
                },
                child: Text('Show Progress Dialog Without Message'),
              )
            ],
          ),
        ));
  }

  Future<void> showProgress(BuildContext context) async {
    var result = await showDialog(
        context: context,
        child: FutureProgressDialog(getFuture(), 'Loading...'));
    showResultDialog(context, result);
  }

  Future<void> showProgressWithoutMsg(BuildContext context) async {
    var result = await showDialog(
        context: context, child: FutureProgressDialog(getFuture(), null));
    showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      child: AlertDialog(
        content: Text(result),
        actions: <Widget>[
          FlatButton(
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

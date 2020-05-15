import 'package:flutter/material.dart';

class FutureProgressDialog extends StatelessWidget {
  final Future future;
  final String message;
  FutureProgressDialog(this.future, this.message);

  @override
  Widget build(BuildContext context) {
    future.then((val) {
      Navigator.of(context).pop(val);
    }).catchError((e) {
      Navigator.of(context).pop();
    });

    return WillPopScope(
      child: _buildDialog(context),
      onWillPop: () {
        return Future(() {
          return false;
        });
      },
    );
  }

  Widget _buildDialog(BuildContext context) {
    if (message == null) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _CustomProgressWidget(),
      );
    }
    return AlertDialog(
      content:
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(width: 20),
        _buildText(context)
      ]),
    );
  }

  Widget _buildText(BuildContext context) {
    if (message == null) {
      return SizedBox.shrink();
    }
    return Expanded(
      flex: 1,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 15,
        ),
      ),
    );
  }
}


class _CustomProgressWidget extends StatelessWidget {
  const _CustomProgressWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
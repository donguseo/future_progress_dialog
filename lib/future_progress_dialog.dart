import 'package:flutter/material.dart';

const _DefaultDecoration = BoxDecoration(
  color: Colors.white,
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class FutureProgressDialog extends StatefulWidget {
  /// Dialog will be closed when [future] task is finished.
  final Future future;

  /// [BoxDecoration] of [FutureProgressDialog].
  final BoxDecoration? decoration;

  /// opacity of [FutureProgressDialog]
  final double opacity;

  /// If you want to use custom progress widget set [progress].
  final Widget? progress;

  /// If you want to use message widget set [message].
  final Widget? message;

  /// Label of the cancel button. When set, a cancel button is rendered below
  /// the progress indicator. Pressing it closes the dialog with `null` and
  /// invokes [onCancel] before closing.
  final String? cancelLabel;

  /// Callback invoked when the cancel button is pressed, before the dialog is
  /// closed.
  final VoidCallback? onCancel;

  const FutureProgressDialog(
    this.future, {
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    this.message,
    this.cancelLabel,
    this.onCancel,
  });

  @override
  _FutureProgressDialogState createState() => _FutureProgressDialogState();
}

class _FutureProgressDialogState extends State<FutureProgressDialog> {
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    widget.future.then((val) {
      _close(val);
    }).catchError((e) {
      _close();
      throw e;
    });
  }

  void _close([dynamic value]) {
    if (_closed || !mounted) {
      return;
    }
    _closed = true;
    Navigator.of(context).pop(value);
  }

  void _handleCancel() {
    widget.onCancel?.call();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: _buildDialog(context),
    );
  }

  Widget _buildDialog(BuildContext context) {
    final Widget progress = widget.progress ?? const CircularProgressIndicator();
    final bool hasCancel = widget.cancelLabel != null;

    Widget content;
    if (widget.message == null && !hasCancel) {
      content = Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: widget.decoration ?? _DefaultDecoration,
          child: progress,
        ),
      );
    } else {
      content = Container(
        padding: const EdgeInsets.all(20),
        decoration: widget.decoration ?? _DefaultDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                progress,
                if (widget.message != null) ...[
                  const SizedBox(width: 20),
                  Flexible(flex: 1, child: widget.message!),
                ],
              ],
            ),
            if (hasCancel) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: _handleCancel,
                child: Text(widget.cancelLabel!),
              ),
            ],
          ],
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Opacity(
        opacity: widget.opacity,
        child: content,
      ),
    );
  }
}

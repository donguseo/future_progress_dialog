import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

Widget _buildApp(Future future, {String? cancelLabel, VoidCallback? onCancel}) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (context) => FutureProgressDialog(
                  future,
                  message: const Text('Loading...'),
                  cancelLabel: cancelLabel,
                  onCancel: onCancel,
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('dialog closes automatically with the future result', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(_buildApp(completer.future));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(FutureProgressDialog), findsOneWidget);

    completer.complete('done');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(FutureProgressDialog), findsNothing);
  });

  testWidgets('cancel button is not shown when cancelLabel is null', (tester) async {
    final completer = Completer<String>();

    await tester.pumpWidget(_buildApp(completer.future));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(FutureProgressDialog), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);

    completer.complete('done');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('cancel button calls onCancel and closes the dialog with null', (tester) async {
    final completer = Completer<String>();
    String? result;
    var canceled = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await showDialog<String>(
                  context: context,
                  builder: (context) => FutureProgressDialog(
                    completer.future,
                    message: const Text('Loading...'),
                    cancelLabel: 'Cancel',
                    onCancel: () => canceled = true,
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(FutureProgressDialog), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(canceled, isTrue);
    expect(find.byType(FutureProgressDialog), findsNothing);
    expect(result, isNull);

    completer.complete('done');
    await tester.pump();
  });
}

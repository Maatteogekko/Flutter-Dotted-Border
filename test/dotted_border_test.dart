import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Run test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DottedBorder(
            child: const Text('test'),
          ),
        ),
      ),
    );

    expect(find.byType(DottedBorder), findsOneWidget);
  });
}

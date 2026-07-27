import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_app/main.dart';

void main() {
  testWidgets('admin dashboard keeps only analytics and quick actions', (
      WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));

    expect(find.text('System Analytics'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Book List & QR Codes'), findsNothing);
    expect(find.text('Borrowed Books Log'), findsNothing);
    expect(find.text('Student Directory'), findsNothing);
  });
}

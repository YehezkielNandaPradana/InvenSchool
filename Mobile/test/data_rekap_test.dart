import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/features/data_rekap/data_rekap_page.dart';

void main() {
  testWidgets('Data rekap page should render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DataRekapPage()),
    );
    expect(find.byType(DataRekapPage), findsOneWidget);
  });
}

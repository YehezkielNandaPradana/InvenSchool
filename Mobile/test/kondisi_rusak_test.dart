import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/features/kondisi_rusak/kondisi_rusak_page.dart';

void main() {
  testWidgets('Kondisi rusak page should render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: KondisiRusakPage()),
    );
    expect(find.byType(KondisiRusakPage), findsOneWidget);
  });
}

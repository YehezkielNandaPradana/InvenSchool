import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/features/barang_masuk/barang_masuk_page.dart';

void main() {
  testWidgets('Barang masuk page should render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: BarangMasukPage()),
    );
    expect(find.byType(BarangMasukPage), findsOneWidget);
  });
}

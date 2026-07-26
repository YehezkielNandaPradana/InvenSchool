import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/features/profil/profil_page.dart';

void main() {
  testWidgets('Profil page should render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfilPage()),
    );
    expect(find.byType(ProfilPage), findsOneWidget);
  });
}

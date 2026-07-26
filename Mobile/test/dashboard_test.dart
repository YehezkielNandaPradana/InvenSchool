import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/features/dashboard/dashboard_page.dart';

void main() {
  testWidgets('Dashboard page should render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DashboardPage()),
    );
    expect(find.byType(DashboardPage), findsOneWidget);
  });
}

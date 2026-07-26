import 'package:flutter/material.dart';
import 'package:inventaris_app/shared/widgets/app_bottom_nav.dart';
import 'package:inventaris_app/shared/widgets/app_top_bar.dart';

class AppScaffold extends StatelessWidget {
  final int navIndex;
  final Widget body;
  final Widget? fab;
  final bool showSearch;
  final bool showNotifications;

  const AppScaffold({
    super.key,
    required this.navIndex,
    required this.body,
    this.fab,
    this.showSearch = true,
    this.showNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              showSearch: showSearch,
              showNotifications: showNotifications,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: body,
              ),
            ),
            AppBottomNav(currentIndex: navIndex),
          ],
        ),
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

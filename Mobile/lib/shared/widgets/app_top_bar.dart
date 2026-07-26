import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final bool showSearch;
  final bool showNotifications;

  const AppTopBar({
    super.key,
    this.showSearch = true,
    this.showNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'InvenSchool',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          if (showSearch)
            _iconButton(context, Icons.search_outlined, () {}),
          if (showNotifications) ...[
            const SizedBox(width: 4),
            _iconButton(context, Icons.notifications_outlined, () {}),
          ],
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 24),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_colors.dart';
import 'package:inventaris_app/app/routes/app_routes.dart';
import 'package:inventaris_app/shared/providers/auth_provider.dart';
import 'package:inventaris_app/shared/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

const Color _secondaryContainer = Color(0xFFd5e3fc);
const Color _onSecondaryContainer = Color(0xFF57657a);
const Color _surfaceContainerLow = Color(0xFFf3f4f5);
const Color _surfaceContainerLowest = Color(0xFFffffff);
const Color _surfaceContainerHigh = Color(0xFFecedf0);

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      navIndex: 3,
      showSearch: false,
      body: _ProfilBody(),
    );
  }
}

class _ProfilBody extends StatelessWidget {
  const _ProfilBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        _ProfileHeader(),
        SizedBox(height: 24),
        _SectionHeader(title: 'PENGATURAN APLIKASI'),
        SizedBox(height: 12),
        _SettingsCard(),
        SizedBox(height: 24),
        _SectionHeader(title: 'DUKUNGAN'),
        SizedBox(height: 12),
        _SupportCard(),
        SizedBox(height: 32),
        _LogoutSection(),
        SizedBox(height: 80),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: _surfaceContainerLow,
                  shape: BoxShape.circle,
                  border: Border.all(color: _surfaceContainerHigh, width: 4),
                ),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Budi Santoso',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Admin Inventaris - SMA 1 Jakarta',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, size: 16, color: AppColors.onPrimaryContainer),
                SizedBox(width: 8),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          _SettingItem(
            icon: Icons.manage_accounts,
            title: 'Akun',
            subtitle: 'Username, Password',
            showChevron: true,
          ),
          _SettingsDivider(),
          _SettingItem(
            icon: Icons.notifications_active,
            title: 'Notifikasi',
            subtitle: 'Atur pengingat stok & laporan',
            showToggle: true,
          ),
          _SettingsDivider(),
          _SettingItem(
            icon: Icons.security,
            title: 'Keamanan',
            subtitle: 'Two-factor auth, Login aktif',
            showChevron: true,
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          _SettingItem(
            icon: Icons.help_center,
            title: 'Bantuan',
            subtitle: 'FAQ, Hubungi Support',
            showChevron: true,
          ),
          _SettingsDivider(),
          _SettingItem(
            icon: Icons.info,
            title: 'Tentang InvenSchool',
            subtitle: 'Versi 2.4.0 (Stable Build)',
            showChevron: true,
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showChevron;
  final bool showToggle;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showChevron = false,
    this.showToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _onSecondaryContainer, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (showToggle)
            SizedBox(
              height: 24,
              child: Switch(
                value: true,
                onChanged: (_) {},
                activeTrackColor: AppColors.primary,
              ),
            ),
          if (showChevron)
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.outlineVariant,
    );
  }
}

class _LogoutSection extends StatelessWidget {
  const _LogoutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        }
                      },
                icon: authProvider.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout, size: 20),
                label: Text(
                  authProvider.isLoading ? 'Logging out...' : 'Log Out',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorContainer,
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          '\u00a9 2024 InvenSchool Team. All Rights Reserved.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

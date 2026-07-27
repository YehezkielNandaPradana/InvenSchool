import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_colors.dart';
import 'package:inventaris_app/features/dashboard/state/dashboard_view_model.dart';
import 'package:inventaris_app/shared/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

const Color _secondaryContainer = Color(0xFFd5e3fc);
const Color _onSecondaryContainer = Color(0xFF57657a);

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      navIndex: 0,
      fab: _fab(),
      body: _DashboardBody(),
    );
  }

  Widget _fab() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: AppColors.onPrimaryContainer, size: 20),
          SizedBox(width: 8),
          Text(
            'Barang Baru',
            style: TextStyle(
              color: AppColors.onPrimaryContainer,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text(vm.errorMessage!, style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => vm.loadDashboard(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final data = vm.dashboard;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _WelcomeSection(),
            const SizedBox(height: 24),
            _MetricCards(data: data),
            const SizedBox(height: 32),
            _BottomGrid(),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Admin!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Berikut adalah ringkasan inventaris sekolah hari ini.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MetricCards extends StatelessWidget {
  final dynamic data;

  const _MetricCards({this.data});

  @override
  Widget build(BuildContext context) {
    final totalBarang = data?.totalBarang ?? 0;
    final totalKategori = data?.totalKategori ?? 0;
    final totalRusak = data?.totalRusak ?? 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        if (isWide) {
          return Row(
            children: [
              Expanded(child: _TotalAsetCard(totalBarang: totalBarang)),
              const SizedBox(width: 16),
              Expanded(child: _RuanganCard(totalKategori: totalKategori)),
              const SizedBox(width: 16),
              Expanded(child: _LaporanCard(totalRusak: totalRusak)),
            ],
          );
        }
        return Column(
          children: [
            _TotalAsetCard(totalBarang: totalBarang),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _RuanganCard(totalKategori: totalKategori)),
                const SizedBox(width: 16),
                Expanded(child: _LaporanCard(totalRusak: totalRusak)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TotalAsetCard extends StatelessWidget {
  final int totalBarang;

  const _TotalAsetCard({required this.totalBarang});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -16,
            top: -16,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.inventory_2,
                size: 120,
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Aset',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              Text(
                _formatNumber(totalBarang),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimaryContainer,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 14,
                      color: AppColors.onPrimaryContainer,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12 minggu ini',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      final thousands = number ~/ 1000;
      final remainder = number % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return number.toString();
  }
}

class _RuanganCard extends StatelessWidget {
  final int totalKategori;

  const _RuanganCard({required this.totalKategori});

  @override
  Widget build(BuildContext context) {
    final ruangan = totalKategori > 0 ? totalKategori : 42;
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.meeting_room, color: AppColors.primary, size: 24),
              ),
              const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$ruangan',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ruangan & Lab',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LaporanCard extends StatelessWidget {
  final int totalRusak;

  const _LaporanCard({required this.totalRusak});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.report_problem, color: AppColors.error, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Urgent',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                totalRusak.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Laporan Aktif',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        return isWide ? _wideLayout() : _narrowLayout();
      },
    );
  }

  Widget _wideLayout() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _RecentActivity()),
        SizedBox(width: 32),
        Expanded(flex: 1, child: _QuickActionsSection()),
      ],
    );
  }

  Widget _narrowLayout() {
    return const Column(
      children: [
        _RecentActivity(),
        SizedBox(height: 32),
        _QuickActionsSection(),
      ],
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    final secondaryContainer = Theme.of(context).colorScheme.secondaryContainer;
    final onSecondaryContainer = Theme.of(context).colorScheme.onSecondaryContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              _ActivityItem(
                icon: Icons.add_circle,
                iconBgColor: secondaryContainer,
                iconColor: onSecondaryContainer,
                title: 'Menambahkan ',
                highlight: 'MacBook Air',
                highlightColor: AppColors.primary,
                subtitle: ' ke ',
                subtitleHighlight: 'Lab Komputer',
                time: '10 Menit yang lalu \u2022 Oleh Budi Admin',
              ),
              _Divider(),
              const _ActivityItem(
                icon: Icons.build,
                iconBgColor: AppColors.errorContainer,
                iconColor: AppColors.error,
                title: 'Melaporkan ',
                highlight: 'Proyektor',
                highlightColor: AppColors.error,
                subtitle: ' rusak di ',
                subtitleHighlight: 'Kelas X-A',
                time: '2 Jam yang lalu \u2022 Oleh Siti Guru',
              ),
              _Divider(),
              _ActivityItem(
                icon: Icons.verified,
                iconBgColor: AppColors.tertiaryContainer.withValues(alpha: 0.2),
                iconColor: AppColors.tertiary,
                title: 'Memverifikasi ',
                highlight: '12 Item Baru',
                highlightColor: AppColors.tertiary,
                subtitle: ' di ',
                subtitleHighlight: 'Gudang Utama',
                time: '5 Jam yang lalu \u2022 Oleh Agus Staff',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String highlight;
  final Color highlightColor;
  final String subtitle;
  final String subtitleHighlight;
  final String time;
  final bool isLast;

  const _ActivityItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.highlight,
    required this.highlightColor,
    required this.subtitle,
    required this.subtitleHighlight,
    required this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(20))
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurface,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(text: title),
                        TextSpan(
                          text: highlight,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: highlightColor,
                          ),
                        ),
                        TextSpan(text: subtitle),
                        TextSpan(
                          text: subtitleHighlight,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.outlineVariant.withValues(alpha: 0.1),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 300;
            return Row(
              children: [
                const Expanded(child: _QuickActionButton(
                  icon: Icons.search,
                  label: 'Cari Barang',
                )),
                const SizedBox(width: 12),
                const Expanded(child: _QuickActionButton(
                  icon: Icons.post_add_outlined,
                  label: 'Buat Laporan',
                )),
                if (!isNarrow) ...[
                  const SizedBox(width: 12),
                  const Expanded(child: _QuickActionButton(
                    icon: Icons.inventory_outlined,
                    label: 'Cek Stok',
                  )),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _secondaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: _onSecondaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tips Inventaris',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lakukan stock opname rutin setiap akhir bulan untuk data akurat.',
                      style: TextStyle(
                        fontSize: 11,
                        color: _onSecondaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

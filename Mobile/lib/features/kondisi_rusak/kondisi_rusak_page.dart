import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_colors.dart';
import 'package:inventaris_app/shared/widgets/app_scaffold.dart';

const Color _surfaceContainerLow = Color(0xFFf3f4f5);
const Color _secondaryContainer = Color(0xFFd5e3fc);
const Color _onSecondaryContainer = Color(0xFF57657a);

class KondisiRusakPage extends StatelessWidget {
  const KondisiRusakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      navIndex: 2,
      fab: _fab(),
      body: const _KondisiRusakBody(),
    );
  }

  Widget _fab() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.report_problem, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Laporkan Kerusakan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _KondisiRusakBody extends StatelessWidget {
  const _KondisiRusakBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 8),
        _Header(),
        SizedBox(height: 24),
        _StatCards(),
        SizedBox(height: 24),
        _SearchBar(),
        SizedBox(height: 16),
        _FilterChips(),
        SizedBox(height: 24),
        _DamageGrid(),
        SizedBox(height: 80),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kondisi Rusak',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pantau dan kelola laporan kerusakan aset sekolah',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatCards extends StatelessWidget {
  const _StatCards();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        if (isWide) {
          return const Row(
            children: [
              Expanded(child: _TotalRusakCard()),
              SizedBox(width: 16),
              Expanded(child: _PerluPerbaikanCard()),
              SizedBox(width: 16),
              Expanded(child: _TidakBisaCard()),
            ],
          );
        }
        return const Column(
          children: [
            _TotalRusakCard(),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _PerluPerbaikanCard()),
                SizedBox(width: 16),
                Expanded(child: _TidakBisaCard()),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TotalRusakCard extends StatelessWidget {
  const _TotalRusakCard();

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
          Positioned(
            right: -16,
            top: -16,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.broken_image,
                size: 120,
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.broken_image, color: AppColors.onPrimaryContainer, size: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Barang Rusak',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '42',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.trending_up, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  const Text(
                    '+5 bln ini',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerluPerbaikanCard extends StatelessWidget {
  const _PerluPerbaikanCard();

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
                  color: AppColors.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.build, color: AppColors.tertiary, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '18',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Perlu Perbaikan',
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

class _TidakBisaCard extends StatelessWidget {
  const _TidakBisaCard();

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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.dangerous, color: AppColors.error, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '24',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tidak Bisa Digunakan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Penghapusan Aset',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari laporan kerusakan...',
        hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6)),
        prefixIcon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
        filled: true,
        fillColor: _surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _Chip(label: 'Semua', selected: true),
          SizedBox(width: 8),
          _Chip(label: 'Ringan'),
          SizedBox(width: 8),
          _Chip(label: 'Sedang'),
          SizedBox(width: 8),
          _Chip(label: 'Berat'),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;

  const _Chip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? _secondaryContainer : _surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? _secondaryContainer : AppColors.outlineVariant,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: selected ? _onSecondaryContainer : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DamageGrid extends StatelessWidget {
  const _DamageGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900 ? 3 : (constraints.maxWidth >= 600 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
          children: const [
            _DamageCard(
              title: 'Kursi Ergonomis X-1',
              severity: 'Berat',
              location: 'Lab Komputer 1',
              description: 'Sandaran kursi patah, dudukan longgar dan tidak bisa dipakai untuk belajar.',
              reporter: 'Dina Guru',
              inventoryCode: 'INV/KRS/001',
              daysAgo: '3 hari lalu',
            ),
            _DamageCard(
              title: 'Proyektor Epson EB',
              severity: 'Sedang',
              location: 'Kelas XII-IPA 2',
              description: 'Lensa buram, gambar tidak fokus dan terkadang mati sendiri.',
              reporter: 'Pak Rahmat',
              inventoryCode: 'INV/PRJ/012',
              daysAgo: '5 hari lalu',
            ),
            _DamageCard(
              title: 'Laptop Chromebook',
              severity: 'Ringan',
              location: 'Perpustakaan',
              description: 'Beberapa tombol keyboard lepas dan touchpad tidak responsif.',
              reporter: 'Ibu Sari',
              inventoryCode: 'INV/LPT/045',
              daysAgo: '1 minggu lalu',
            ),
          ],
        );
      },
    );
  }
}

class _DamageCard extends StatelessWidget {
  final String title;
  final String severity;
  final String location;
  final String description;
  final String reporter;
  final String inventoryCode;
  final String daysAgo;

  const _DamageCard({
    required this.title,
    required this.severity,
    required this.location,
    required this.description,
    required this.reporter,
    required this.inventoryCode,
    required this.daysAgo,
  });

  Color _severityColor() {
    switch (severity) {
      case 'Berat':
        return AppColors.error;
      case 'Sedang':
        return AppColors.warning;
      case 'Ringan':
        return AppColors.success;
      default:
        return AppColors.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFe8e9ea),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(Icons.image_outlined, size: 40, color: AppColors.outline.withValues(alpha: 0.5)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _severityColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    severity,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    inventoryCode,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: AppColors.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.outline),
                      const SizedBox(width: 4),
                      Text(
                        daysAgo,
                        style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\u201c',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.outline,
                            fontStyle: FontStyle.italic,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          reporter[0],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reporter,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.more_vert, size: 18, color: AppColors.onSurfaceVariant),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

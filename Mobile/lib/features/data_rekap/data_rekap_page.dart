import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_colors.dart';
import 'package:inventaris_app/shared/widgets/app_scaffold.dart';

const Color _surfaceContainerLow = Color(0xFFf3f4f5);
const Color _surfaceContainerLowest = Color(0xFFffffff);

class DataRekapPage extends StatelessWidget {
  const DataRekapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      navIndex: 2,
      body: _DataRekapBody(),
    );
  }
}

class _DataRekapBody extends StatelessWidget {
  const _DataRekapBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        _Header(),
        SizedBox(height: 24),
        _StatCards(),
        SizedBox(height: 24),
        _FilterSection(),
        SizedBox(height: 24),
        _ChartArea(),
        SizedBox(height: 24),
        _DataTableSection(),
        SizedBox(height: 24),
        _SummarySection(),
        SizedBox(height: 24),
        _ExportButtons(),
        SizedBox(height: 80),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Rekap',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Laporan inventaris sekolah periode aktif.',
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
        final cards = const [
          _StatCard(
            bgColor: AppColors.primaryContainer,
            icon: Icons.inventory,
            iconColor: AppColors.onPrimaryContainer,
            label: 'Total Inventaris',
            value: '1,284',
            badge: '+12%',
            badgeColor: Colors.white,
          ),
          _StatCard(
            bgColor: _surfaceContainerLowest,
            icon: Icons.file_download,
            iconColor: AppColors.primary,
            label: 'Barang Masuk',
            value: '42',
            borderColor: AppColors.outlineVariant,
          ),
          _StatCard(
            bgColor: _surfaceContainerLowest,
            icon: Icons.file_upload,
            iconColor: AppColors.tertiary,
            label: 'Barang Keluar',
            value: '18',
            borderColor: AppColors.outlineVariant,
          ),
          _StatCard(
            bgColor: AppColors.errorContainer,
            icon: Icons.report_problem,
            iconColor: AppColors.error,
            label: 'Barang Rusak',
            value: '7',
          ),
        ];

        if (isWide) {
          return Row(
            children: cards.map((c) => Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: c,
            ))).toList(),
          );
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 12),
                Expanded(child: cards[1]),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: cards[2]),
                const SizedBox(width: 12),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? badge;
  final Color? badgeColor;
  final Color? borderColor;

  const _StatCard({
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.badge,
    this.badgeColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border.all(color: borderColor!.withValues(alpha: 0.3))
            : null,
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
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? Colors.white).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: borderColor != null ? AppColors.onSurface : AppColors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: borderColor != null
                      ? AppColors.onSurfaceVariant
                      : AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Laporan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return const Row(
                  children: [
                    Expanded(child: _FilterChip(label: 'Rentang Tanggal', icon: Icons.date_range)),
                    SizedBox(width: 12),
                    Expanded(child: _FilterChip(label: 'Kategori', icon: Icons.category)),
                    SizedBox(width: 12),
                    Expanded(child: _FilterChip(label: 'Lokasi', icon: Icons.location_on)),
                  ],
                );
              }
              return const Column(
                children: [
                  _FilterChip(label: 'Rentang Tanggal', icon: Icons.date_range),
                  SizedBox(height: 12),
                  _FilterChip(label: 'Kategori', icon: Icons.category),
                  SizedBox(height: 12),
                  _FilterChip(label: 'Lokasi', icon: Icons.location_on),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FilterChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 20, color: AppColors.outline),
        ],
      ),
    );
  }
}

class _ChartArea extends StatelessWidget {
  const _ChartArea();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _BarChart()),
              SizedBox(width: 16),
              Expanded(child: _PieChart()),
            ],
          );
        }
        return const Column(
          children: [
            _BarChart(),
            SizedBox(height: 16),
            _PieChart(),
          ],
        );
      },
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Inventory',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _BarColumn(label: 'Sep', height: 0.6, value: 850),
                const SizedBox(width: 12),
                _BarColumn(label: 'Okt', height: 0.75, value: 1020),
                const SizedBox(width: 12),
                _BarColumn(label: 'Nov', height: 0.9, value: 1200),
                const SizedBox(width: 12),
                _BarColumn(label: 'Des', height: 1.0, value: 1284),
                const SizedBox(width: 12),
                _BarColumn(label: 'Jan', height: 0.85, value: 1150),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final String label;
  final double height;
  final int value;

  const _BarColumn({
    required this.label,
    required this.height,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 140 * height,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.8),
                  AppColors.primary,
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChart extends StatelessWidget {
  const _PieChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kondisi Barang',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size(120, 120),
                          child: CustomPaint(
                            painter: _PieChartPainter(),
                          ),
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1,284',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: _PieLegend(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const strokeWidth = 18.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const data = [
      (color: Color(0xFF22C55E), percent: 0.65),
      (color: Color(0xFFF59E0B), percent: 0.15),
      (color: Color(0xFFEF4444), percent: 0.10),
      (color: Color(0xFF3B82F6), percent: 0.10),
    ];

    double startAngle = -1.5708;
    for (final d in data) {
      final sweep = d.percent * 6.28319;
      paint.color = d.color;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PieLegend extends StatelessWidget {
  const _PieLegend();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: Color(0xFF22C55E), label: 'Baik', value: '834'),
        SizedBox(height: 8),
        _LegendItem(color: Color(0xFFF59E0B), label: 'Rusak Ringan', value: '193'),
        SizedBox(height: 8),
        _LegendItem(color: Color(0xFFEF4444), label: 'Rusak Berat', value: '128'),
        SizedBox(height: 8),
        _LegendItem(color: Color(0xFF3B82F6), label: 'Dipinjam', value: '129'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _DataTableSection extends StatelessWidget {
  const _DataTableSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Aset',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: _surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: DataTable(
              headingRowHeight: 48,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 52,
              horizontalMargin: 16,
              columnSpacing: 24,
              headingRowColor: WidgetStateProperty.all(_surfaceContainerLow),
              columns: [
                const DataColumn(label: Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const DataColumn(label: Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const DataColumn(label: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const DataColumn(label: Text('Kondisi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const DataColumn(label: Text('Lokasi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              ],
              rows: [
                _tableRow('MacBook Air', 'Elektronik', '12', 'Baik', 'Lab Komputer', 'Tersedia', const Color(0xFF22C55E)),
                _tableRow('Proyektor', 'Elektronik', '8', 'Rusak Ringan', 'Kelas X-A', 'Dipinjam', const Color(0xFFF59E0B)),
                _tableRow('Meja Kayu', 'Furnitur', '45', 'Rusak Berat', 'Gudang', 'Perbaikan', const Color(0xFFEF4444)),
                _tableRow('Mikroskop', 'Lab', '6', 'Baik', 'Lab IPA', 'Tersedia', const Color(0xFF3B82F6)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

DataRow _tableRow(String name, String category, String qty, String condition, String location, String status, Color statusColor) {
  return DataRow(cells: [
    DataCell(Text(name, style: const TextStyle(fontSize: 13, color: AppColors.onSurface))),
    DataCell(Text(category, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant))),
    DataCell(Text(qty, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface))),
    DataCell(Text(condition, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant))),
    DataCell(Text(location, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant))),
    DataCell(_StatusBadge(label: status, color: statusColor)),
  ]);
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 500) {
            return const Row(
              children: [
                Expanded(child: _SummaryLeft()),
                SizedBox(width: 24),
                Expanded(child: _SummaryRight()),
              ],
            );
          }
          return const Column(
            children: [
              _SummaryLeft(),
              SizedBox(height: 16),
              _SummaryRight(),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryLeft extends StatelessWidget {
  const _SummaryLeft();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Ringkas',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 12),
        _StatRow(color: Color(0xFF22C55E), label: 'Total Items', value: '1,284'),
        SizedBox(height: 8),
        _StatRow(color: AppColors.primary, label: 'Kondisi Baik', value: '834'),
        SizedBox(height: 8),
        _StatRow(color: AppColors.error, label: 'Total Rusak', value: '321'),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _StatRow({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _SummaryRight extends StatelessWidget {
  const _SummaryRight();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Informasi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Terakhir diperbarui: 15 Jan 2026',
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 4),
          Text(
            'Data tersinkronisasi secara otomatis.',
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ExportButtons extends StatelessWidget {
  const _ExportButtons();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 500) {
          return const Row(
            children: [
              Expanded(child: _ExportButton(label: 'Export PDF', color: AppColors.error, icon: Icons.picture_as_pdf)),
              SizedBox(width: 12),
              Expanded(child: _ExportButton(label: 'Export Excel', color: Color(0xFF15803D), icon: Icons.table_chart)),
              SizedBox(width: 12),
              Expanded(child: _ExportButton(label: 'Print Report', color: null, icon: Icons.print, outlined: true)),
            ],
          );
        }
        return const Column(
          children: [
            _ExportButton(label: 'Export PDF', color: AppColors.error, icon: Icons.picture_as_pdf),
            SizedBox(height: 12),
            _ExportButton(label: 'Export Excel', color: Color(0xFF15803D), icon: Icons.table_chart),
            SizedBox(height: 12),
            _ExportButton(label: 'Print Report', color: null, icon: Icons.print, outlined: true),
          ],
        );
      },
    );
  }
}

class _ExportButton extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData icon;
  final bool outlined;

  const _ExportButton({
    required this.label,
    this.color,
    required this.icon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: outlined ? null : color,
        borderRadius: BorderRadius.circular(24),
        border: outlined ? Border.all(color: AppColors.outlineVariant) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: outlined ? AppColors.onSurface : Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: outlined ? AppColors.onSurface : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

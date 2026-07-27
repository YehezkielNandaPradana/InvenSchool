import 'package:flutter/material.dart';
import 'package:inventaris_app/app/constants/app_colors.dart';
import 'package:inventaris_app/data/models/barang_masuk/barang_masuk_model.dart';
import 'package:inventaris_app/features/barang_masuk/state/barang_masuk_view_model.dart';
import 'package:inventaris_app/shared/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

const Color _greenText = Color(0xFF065F46);

class BarangMasukPage extends StatelessWidget {
  const BarangMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return AppScaffold(
      navIndex: 1,
      fab: isWide
          ? Container(
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
                    'Tambah Barang',
                    style: TextStyle(
                      color: AppColors.onPrimaryContainer,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _merkController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _supplierController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _kategori;
  String? _kondisiAwal;

  static const _kategoriOptions = [
    'Elektronik',
    'Furniture',
    'Alat Tulis',
    'Peralatan Lab',
    'Olahraga',
    'Lainnya',
  ];

  static const _kondisiOptions = ['Baru', 'Baik', 'Rusak Ringan', 'Rusak Berat'];

  @override
  void dispose() {
    _namaController.dispose();
    _merkController.dispose();
    _jumlahController.dispose();
    _lokasiController.dispose();
    _tanggalController.dispose();
    _supplierController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarangMasukViewModel>(
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
                  onPressed: () => vm.loadItems(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
        return _buildContent(vm.items);
      },
    );
  }

  Widget _buildContent(List<BarangMasukModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const _Header(),
        const SizedBox(height: 24),
        const _SummaryCards(),
        const SizedBox(height: 24),
        _TwoColumnLayout(form: _buildForm(), items: items),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 500;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Form Barang Masuk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                if (isWide) _buildWideFormFields() else _buildNarrowFormFields(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Simpan Barang Masuk'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWideFormFields() {
    return Column(
      children: [
        _buildTextField(_namaController, 'Nama Barang'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDropdown('Kategori', _kategoriOptions, _kategori, (v) => setState(() => _kategori = v))),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(_merkController, 'Merk')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(_jumlahController, 'Jumlah', keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildDropdown('Kondisi Awal', _kondisiOptions, _kondisiAwal, (v) => setState(() => _kondisiAwal = v))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(_lokasiController, 'Lokasi Penyimpanan')),
            const SizedBox(width: 16),
            Expanded(child: _buildDateField(_tanggalController, 'Tanggal Masuk')),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(_supplierController, 'Supplier'),
        const SizedBox(height: 16),
        _buildTextField(_keteranganController, 'Keterangan', maxLines: 3),
      ],
    );
  }

  Widget _buildNarrowFormFields() {
    return Column(
      children: [
        _buildTextField(_namaController, 'Nama Barang'),
        const SizedBox(height: 16),
        _buildDropdown('Kategori', _kategoriOptions, _kategori, (v) => setState(() => _kategori = v)),
        const SizedBox(height: 16),
        _buildTextField(_merkController, 'Merk'),
        const SizedBox(height: 16),
        _buildTextField(_jumlahController, 'Jumlah', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildDropdown('Kondisi Awal', _kondisiOptions, _kondisiAwal, (v) => setState(() => _kondisiAwal = v)),
        const SizedBox(height: 16),
        _buildTextField(_lokasiController, 'Lokasi Penyimpanan'),
        const SizedBox(height: 16),
        _buildDateField(_tanggalController, 'Tanggal Masuk'),
        const SizedBox(height: 16),
        _buildTextField(_supplierController, 'Supplier'),
        const SizedBox(height: 16),
        _buildTextField(_keteranganController, 'Keterangan', maxLines: 3),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        hintText: 'Pilih tanggal',
        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: AppColors.onSurfaceVariant),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          controller.text =
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        }
      },
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
          'Barang Masuk',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Input dan manajemen inventaris sekolah terbaru.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 400;
        final cards = [
          _SummaryCardData(
            icon: Icons.analytics,
            iconBgColor: AppColors.primary.withValues(alpha: 0.1),
            iconColor: AppColors.primary,
            label: 'TOTAL BARANG HARI INI',
            value: '24 Unit',
          ),
          _SummaryCardData(
            icon: Icons.pending_actions,
            iconBgColor: AppColors.tertiary.withValues(alpha: 0.1),
            iconColor: AppColors.tertiary,
            label: 'MENUNGGU VERIFIKASI',
            value: '12 Items',
          ),
        ];
        if (isWide) {
          return Row(
            children: [
              Expanded(child: _SummaryCard(data: cards[0])),
              const SizedBox(width: 16),
              Expanded(child: _SummaryCard(data: cards[1])),
            ],
          );
        }
        return Column(
          children: [
            _SummaryCard(data: cards[0]),
            const SizedBox(height: 12),
            _SummaryCard(data: cards[1]),
          ],
        );
      },
    );
  }
}

class _SummaryCardData {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryCardData({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
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

class _TwoColumnLayout extends StatelessWidget {
  final Widget form;
  final List<BarangMasukModel> items;

  const _TwoColumnLayout({required this.form, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: form),
              const SizedBox(width: 24),
              Expanded(flex: 5, child: _RecentItemsList(items: items)),
            ],
          );
        }
        return Column(
          children: [
            form,
            const SizedBox(height: 24),
            _RecentItemsList(items: items),
          ],
        );
      },
    );
  }
}

class _RecentItemsList extends StatelessWidget {
  final List<BarangMasukModel> items;

  const _RecentItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    final displayItems = items.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Barang Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (displayItems.isEmpty)
          const _EmptyState()
        else
          ...displayItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ItemCard(item: item),
              )),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Text(
          'Belum ada barang masuk',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final BarangMasukModel item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.gambar != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.gambar!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.inventory_2,
                        color: AppColors.onSurfaceVariant,
                        size: 28,
                      ),
                    ),
                  )
                : const Icon(Icons.inventory_2, color: AppColors.onSurfaceVariant, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.namaBarang,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Baru',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _greenText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.kategori} • ${item.jumlah} ${item.satuan}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.kondisi ?? '-'} • ${_formatTime(item.tanggalMasuk)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '-';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    if (diff.inDays < 7) return '${diff.inDays}h lalu';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}

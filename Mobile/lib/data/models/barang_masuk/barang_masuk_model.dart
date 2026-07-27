class BarangMasukModel {
  final int id;
  final String namaBarang;
  final String kategori;
  final int jumlah;
  final String satuan;
  final String? kondisi;
  final String? catatan;
  final DateTime? tanggalMasuk;
  final String? gambar;

  const BarangMasukModel({
    required this.id,
    required this.namaBarang,
    required this.kategori,
    required this.jumlah,
    required this.satuan,
    this.kondisi,
    this.catatan,
    this.tanggalMasuk,
    this.gambar,
  });

  factory BarangMasukModel.fromJson(Map<String, dynamic> json) {
    return BarangMasukModel(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',
      kategori: json['kategori'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      satuan: json['satuan'] ?? '',
      kondisi: json['kondisi'],
      catatan: json['catatan'],
      tanggalMasuk:
          json['tanggal_masuk'] != null
              ? DateTime.tryParse(json['tanggal_masuk'])
              : null,
      gambar: json['gambar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori': kategori,
      'jumlah': jumlah,
      'satuan': satuan,
      'kondisi': kondisi,
      'catatan': catatan,
      'tanggal_masuk': tanggalMasuk?.toIso8601String(),
      'gambar': gambar,
    };
  }
}

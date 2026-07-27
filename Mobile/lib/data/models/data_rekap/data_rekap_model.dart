class DataRekapModel {
  final int id;
  final String namaBarang;
  final String kategori;
  final int jumlah;
  final String lokasi;
  final DateTime? updatedAt;

  const DataRekapModel({
    required this.id,
    required this.namaBarang,
    required this.kategori,
    required this.jumlah,
    required this.lokasi,
    this.updatedAt,
  });

  factory DataRekapModel.fromJson(Map<String, dynamic> json) {
    return DataRekapModel(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',
      kategori: json['kategori'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      lokasi: json['lokasi'] ?? '',
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori': kategori,
      'jumlah': jumlah,
      'lokasi': lokasi,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

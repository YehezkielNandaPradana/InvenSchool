class KondisiRusakModel {
  final int id;
  final String namaBarang;
  final String kategori;
  final String kondisi;
  final String? deskripsiKerusakan;
  final DateTime? tanggalLapor;
  final String? status;

  KondisiRusakModel({
    required this.id,
    required this.namaBarang,
    required this.kategori,
    required this.kondisi,
    this.deskripsiKerusakan,
    this.tanggalLapor,
    this.status,
  });

  factory KondisiRusakModel.fromJson(Map<String, dynamic> json) {
    return KondisiRusakModel(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',
      kategori: json['kategori'] ?? '',
      kondisi: json['kondisi'] ?? '',
      deskripsiKerusakan: json['deskripsi_kerusakan'],
      tanggalLapor:
          json['tanggal_lapor'] != null
              ? DateTime.tryParse(json['tanggal_lapor'])
              : null,
      status: json['status'],
    );
  }
}

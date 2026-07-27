class DashboardModel {
  final int totalBarang;
  final int totalMasuk;
  final int totalRusak;
  final int totalKategori;
  final List<ChartData> chartData;

  DashboardModel({
    required this.totalBarang,
    required this.totalMasuk,
    required this.totalRusak,
    required this.totalKategori,
    required this.chartData,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final list = (json['chart_data'] as List? ?? []);
    return DashboardModel(
      totalBarang: json['total_barang'] ?? 0,
      totalMasuk: json['total_masuk'] ?? 0,
      totalRusak: json['total_rusak'] ?? 0,
      totalKategori: json['total_kategori'] ?? 0,
      chartData: list.map((e) => ChartData.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_barang': totalBarang,
      'total_masuk': totalMasuk,
      'total_rusak': totalRusak,
      'total_kategori': totalKategori,
      'chart_data': chartData.map((e) => e.toJson()).toList(),
    };
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData({required this.label, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(label: json['label'] ?? '', value: json['value'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}

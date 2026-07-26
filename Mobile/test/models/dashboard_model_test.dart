import 'package:flutter_test/flutter_test.dart';
import 'package:inventaris_app/data/models/dashboard/dashboard_model.dart';

void main() {
  group('DashboardModel', () {
    test('should create from JSON', () {
      final json = {
        'total_barang': 100,
        'total_barang_masuk': 50,
        'total_barang_rusak': 5,
        'total_kategori': 10,
      };
      final model = DashboardModel.fromJson(json);
      expect(model.totalBarang, 100);
      expect(model.totalBarangMasuk, 50);
      expect(model.totalBarangRusak, 5);
      expect(model.totalKategori, 10);
    });
  });
}

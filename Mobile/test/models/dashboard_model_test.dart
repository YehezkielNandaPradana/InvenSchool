import 'package:flutter_test/flutter_test.dart';
import 'package:inventaris_app/data/models/dashboard/dashboard_model.dart';

void main() {
  group('DashboardModel', () {
    test('should create from JSON', () {
      final json = {
        'total_barang': 100,
        'total_masuk': 50,
        'total_rusak': 5,
        'total_kategori': 10,
        'chart_data': [
          {'label': 'Jan', 'value': 10},
          {'label': 'Feb', 'value': 20},
        ],
      };
      final model = DashboardModel.fromJson(json);
      expect(model.totalBarang, 100);
      expect(model.totalMasuk, 50);
      expect(model.totalRusak, 5);
      expect(model.totalKategori, 10);
      expect(model.chartData.length, 2);
    });
  });

  group('ChartData', () {
    test('should create from JSON', () {
      final json = {'label': 'Jan', 'value': 10};
      final data = ChartData.fromJson(json);
      expect(data.label, 'Jan');
      expect(data.value, 10);
    });
  });
}

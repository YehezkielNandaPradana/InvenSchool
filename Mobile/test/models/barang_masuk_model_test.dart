import 'package:flutter_test/flutter_test.dart';
import 'package:inventaris_app/data/models/barang_masuk/barang_masuk_model.dart';

void main() {
  group('BarangMasukModel', () {
    test('should create from JSON', () {
      final json = {
        'id': 1,
        'barang_id': 1,
        'jumlah': 10,
        'tanggal_masuk': '2024-01-15',
        'keterangan': 'Barang baru',
      };
      final model = BarangMasukModel.fromJson(json);
      expect(model.id, 1);
      expect(model.barangId, 1);
      expect(model.jumlah, 10);
    });

    test('should convert to JSON', () {
      final model = BarangMasukModel(
        id: 1,
        barangId: 1,
        jumlah: 10,
        tanggalMasuk: '2024-01-15',
        keterangan: 'Barang baru',
      );
      final json = model.toJson();
      expect(json['id'], 1);
      expect(json['jumlah'], 10);
    });
  });
}

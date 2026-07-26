import 'package:flutter_test/flutter_test.dart';
import 'package:inventaris_app/data/models/barang_masuk/barang_masuk_model.dart';

void main() {
  group('BarangMasukModel', () {
    test('should create from JSON', () {
      final json = {
        'id': 1,
        'nama_barang': 'Meja Siswa',
        'kategori': 'Furnitur',
        'jumlah': 10,
        'satuan': 'unit',
        'kondisi': 'baik',
        'catatan': 'Barang baru',
        'tanggal_masuk': '2024-01-15',
      };
      final model = BarangMasukModel.fromJson(json);
      expect(model.id, 1);
      expect(model.namaBarang, 'Meja Siswa');
      expect(model.jumlah, 10);
      expect(model.satuan, 'unit');
    });

    test('should convert to JSON', () {
      final model = BarangMasukModel(
        id: 1,
        namaBarang: 'Meja Siswa',
        kategori: 'Furnitur',
        jumlah: 10,
        satuan: 'unit',
        kondisi: 'baik',
        catatan: 'Barang baru',
        tanggalMasuk: DateTime(2024, 1, 15),
      );
      final json = model.toJson();
      expect(json['id'], 1);
      expect(json['nama_barang'], 'Meja Siswa');
      expect(json['jumlah'], 10);
    });
  });
}

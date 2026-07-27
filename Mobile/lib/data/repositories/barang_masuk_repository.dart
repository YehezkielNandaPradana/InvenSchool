import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/data/datasources/remote/barang_masuk_remote_datasource.dart';
import 'package:inventaris_app/data/models/barang_masuk/barang_masuk_model.dart';

class BarangMasukRepository {
  final BarangMasukRemoteDataSource remoteDataSource;

  const BarangMasukRepository({required this.remoteDataSource});

  Future<List<BarangMasukModel>> getBarangMasuk() async {
    try {
      return await remoteDataSource.getBarangMasuk();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal memuat data barang masuk');
    }
  }

  Future<BarangMasukModel> getBarangMasukDetail(int id) async {
    try {
      return await remoteDataSource.getBarangMasukDetail(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal memuat detail barang');
    }
  }
}

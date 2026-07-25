import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/data/datasources/remote/kondisi_rusak_remote_datasource.dart';
import 'package:inventaris_app/data/models/kondisi_rusak/kondisi_rusak_model.dart';

class KondisiRusakRepository {
  final KondisiRusakRemoteDataSource remoteDataSource;

  KondisiRusakRepository({required this.remoteDataSource});

  Future<List<KondisiRusakModel>> getKondisiRusak() async {
    try {
      return await remoteDataSource.getKondisiRusak();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal memuat data kondisi rusak');
    }
  }
}

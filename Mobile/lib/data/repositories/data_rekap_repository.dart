import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/data/datasources/remote/data_rekap_remote_datasource.dart';
import 'package:inventaris_app/data/models/data_rekap/data_rekap_model.dart';

class DataRekapRepository {
  final DataRekapRemoteDataSource remoteDataSource;

  const DataRekapRepository({required this.remoteDataSource});

  Future<List<DataRekapModel>> getDataRekap() async {
    try {
      return await remoteDataSource.getDataRekap();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal memuat data rekap');
    }
  }
}

import 'package:inventaris_app/core/network/api_endpoints.dart';
import 'package:inventaris_app/data/datasources/base_remote_datasource.dart';
import 'package:inventaris_app/data/models/data_rekap/data_rekap_model.dart';

class DataRekapRemoteDataSource extends BaseRemoteDataSource {
  DataRekapRemoteDataSource({
    required super.apiClient,
    required super.storageService,
  });

  Future<List<DataRekapModel>> getDataRekap() async {
    final response = await apiClient.get(ApiEndpoints.dataRekap);
    final data = response is Map<String, dynamic> ? response['data'] : response;
    final list = (data as List?) ?? [];
    return list.map((e) => DataRekapModel.fromJson(e)).toList();
  }
}

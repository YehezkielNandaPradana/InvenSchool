import 'package:inventaris_app/core/network/api_endpoints.dart';
import 'package:inventaris_app/data/datasources/base_remote_datasource.dart';
import 'package:inventaris_app/data/models/kondisi_rusak/kondisi_rusak_model.dart';

class KondisiRusakRemoteDataSource extends BaseRemoteDataSource {
  KondisiRusakRemoteDataSource({
    required super.apiClient,
    required super.storageService,
  });

  Future<List<KondisiRusakModel>> getKondisiRusak() async {
    final response = await apiClient.get(ApiEndpoints.kondisiRusak);
    final data = response is Map<String, dynamic> ? response['data'] : response;
    final list = (data as List?) ?? [];
    return list.map((e) => KondisiRusakModel.fromJson(e)).toList();
  }
}

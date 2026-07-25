import 'package:inventaris_app/core/network/api_endpoints.dart';
import 'package:inventaris_app/data/datasources/base_remote_datasource.dart';
import 'package:inventaris_app/data/models/barang_masuk/barang_masuk_model.dart';

class BarangMasukRemoteDataSource extends BaseRemoteDataSource {
  BarangMasukRemoteDataSource({
    required super.apiClient,
    required super.storageService,
  });

  Future<List<BarangMasukModel>> getBarangMasuk() async {
    final response = await apiClient.get(ApiEndpoints.barangMasuk);
    final data = response is Map<String, dynamic> ? response['data'] : response;
    final list = (data as List?) ?? [];
    return list.map((e) => BarangMasukModel.fromJson(e)).toList();
  }

  Future<BarangMasukModel> getBarangMasukDetail(int id) async {
    final response = await apiClient.get(ApiEndpoints.barangMasukDetail(id));
    final data = response is Map<String, dynamic> ? response['data'] : response;
    return BarangMasukModel.fromJson(data);
  }
}

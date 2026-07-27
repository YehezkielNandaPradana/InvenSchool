import 'package:inventaris_app/core/network/api_endpoints.dart';
import 'package:inventaris_app/data/datasources/base_remote_datasource.dart';
import 'package:inventaris_app/data/models/profil/profil_model.dart';

class ProfilRemoteDataSource extends BaseRemoteDataSource {
  const ProfilRemoteDataSource({
    required super.apiClient,
    required super.storageService,
  });

  Future<ProfilModel> getProfil() async {
    final response = await apiClient.get(ApiEndpoints.profil);
    final data = response is Map<String, dynamic> ? response['data'] : response;
    return ProfilModel.fromJson(data);
  }

  Future<ProfilModel> updateProfil(ProfilModel profil) async {
    final response = await apiClient.put(
      ApiEndpoints.profilUpdate,
      body: profil.toJson(),
    );
    final data = response is Map<String, dynamic> ? response['data'] : response;
    return ProfilModel.fromJson(data);
  }
}

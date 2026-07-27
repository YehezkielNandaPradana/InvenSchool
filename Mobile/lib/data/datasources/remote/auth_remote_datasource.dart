import 'package:inventaris_app/core/network/api_endpoints.dart';
import 'package:inventaris_app/data/datasources/base_remote_datasource.dart';
import 'package:inventaris_app/data/models/auth/login_model.dart';

class AuthRemoteDataSource extends BaseRemoteDataSource {
  AuthRemoteDataSource({
    required super.apiClient,
    required super.storageService,
  });

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: request.toJson(),
    );
    return LoginResponse.fromJson(response);
  }

  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
    await storageService.removeToken();
  }

  Future<UserModel> getMe() async {
    final response = await apiClient.get(ApiEndpoints.me);
    return UserModel.fromJson(response);
  }
}

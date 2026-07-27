import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/data/datasources/local/auth_local_datasource.dart';
import 'package:inventaris_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:inventaris_app/data/models/auth/login_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<UserModel> login(LoginRequest request) async {
    try {
      final result = await remoteDataSource.login(request);
      await localDataSource.cacheToken(result.token);
      return result.user;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Login gagal');
    }
  }

  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      await localDataSource.clearCache();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final cached = await localDataSource.getCachedToken();
      if (cached == null) return null;
      return await remoteDataSource.getMe();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getCachedToken();
    return token != null && token.isNotEmpty;
  }
}

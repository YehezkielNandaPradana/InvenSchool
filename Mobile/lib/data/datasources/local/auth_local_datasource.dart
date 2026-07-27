import 'package:inventaris_app/data/datasources/base_local_datasource.dart';

class AuthLocalDataSource extends BaseLocalDataSource {
  const AuthLocalDataSource({required super.storageService});

  Future<void> cacheToken(String token) async {
    await storageService.saveToken(token);
  }

  Future<String?> getCachedToken() async {
    return storageService.getToken();
  }

  Future<void> clearCache() async {
    await storageService.clearAll();
  }
}

import 'package:inventaris_app/core/network/storage_service.dart';
import 'package:inventaris_app/data/datasources/base_local_datasource.dart';

class AuthLocalDataSource extends BaseLocalDataSource {
  AuthLocalDataSource({required super.storageService});

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

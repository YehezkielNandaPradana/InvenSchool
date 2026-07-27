import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/core/network/storage_service.dart';

abstract class BaseRemoteDataSource {
  final ApiClient apiClient;
  final StorageService storageService;

  const BaseRemoteDataSource({
    required this.apiClient,
    required this.storageService,
  });
}

import 'package:inventaris_app/core/network/storage_service.dart';

abstract class BaseLocalDataSource {
  final StorageService storageService;

  BaseLocalDataSource({required this.storageService});
}

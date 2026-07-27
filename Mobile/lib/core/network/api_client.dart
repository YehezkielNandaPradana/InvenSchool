import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:inventaris_app/app/constants/app_api_config.dart';
import 'package:inventaris_app/core/network/storage_service.dart';

class ApiClient {
  final Dio dio;
  final StorageService _storageService;

  ApiClient({required this.dio, required StorageService storageService})
    : _storageService = storageService {
    dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      await _checkConnectivity();
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final message = _handleError(e);
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<dynamic> post(String path, {dynamic body}) async {
    try {
      await _checkConnectivity();
      final response = await dio.post(path, data: body);
      return response.data;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final message = _handleError(e);
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<dynamic> put(String path, {dynamic body}) async {
    try {
      await _checkConnectivity();
      final response = await dio.put(path, data: body);
      return response.data;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final message = _handleError(e);
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      await _checkConnectivity();
      final response = await dio.delete(path);
      return response.data;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final message = _handleError(e);
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result.any((r) => r == ConnectivityResult.none)) {
      throw const ServerException('Tidak ada koneksi internet.');
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa koneksi internet Anda.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'];
        if (message != null && message.isNotEmpty) {
          return message;
        }
        if (statusCode == 401) {
          return 'Sesi berakhir. Silakan login kembali.';
        }
        if (statusCode == 404) {
          return 'Data tidak ditemukan.';
        }
        if (statusCode == 500) {
          return 'Terjadi kesalahan pada server.';
        }
        return 'Terjadi kesalahan: $statusCode';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      default:
        return 'Terjadi kesalahan jaringan.';
    }
  }
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

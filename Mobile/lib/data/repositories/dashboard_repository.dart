import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/network/api_client.dart';
import 'package:inventaris_app/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:inventaris_app/data/models/dashboard/dashboard_model.dart';

class DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepository({required this.remoteDataSource});

  Future<DashboardModel> getDashboard() async {
    try {
      return await remoteDataSource.getDashboard();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Gagal memuat dashboard');
    }
  }
}

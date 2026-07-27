import 'package:inventaris_app/core/network/api_endpoints.dart';
import 'package:inventaris_app/data/datasources/base_remote_datasource.dart';
import 'package:inventaris_app/data/models/dashboard/dashboard_model.dart';

class DashboardRemoteDataSource extends BaseRemoteDataSource {
  const DashboardRemoteDataSource({
    required super.apiClient,
    required super.storageService,
  });

  Future<DashboardModel> getDashboard() async {
    final response = await apiClient.get(ApiEndpoints.dashboard);
    return DashboardModel.fromJson(response);
  }
}

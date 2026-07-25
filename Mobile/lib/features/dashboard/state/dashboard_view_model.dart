import 'package:flutter/foundation.dart';
import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/data/models/dashboard/dashboard_model.dart';
import 'package:inventaris_app/data/repositories/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository dashboardRepository;

  DashboardViewModel({required this.dashboardRepository});

  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboard;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardModel? get dashboard => _dashboard;

  Future<void> loadDashboard() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _dashboard = await dashboardRepository.getDashboard();
      _isLoading = false;
      notifyListeners();
    } on ServerFailure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat dashboard';
      _isLoading = false;
      notifyListeners();
    }
  }
}

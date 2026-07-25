import 'package:flutter/foundation.dart';
import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/core/utils/logger.dart';
import 'package:inventaris_app/data/models/auth/login_model.dart';
import 'package:inventaris_app/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;
  UserModel? _user;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final request = LoginRequest(email: email, password: password);
      final user = await authRepository.login(request);
      _user = user;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();

      LoggerUtils.i('Login success: ${user.name}');
      return true;
    } catch (e) {
      _errorMessage = e is ServerFailure ? e.message : 'Terjadi kesalahan';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();
      await authRepository.logout();
      _user = null;
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      _isLoggedIn = isLoggedIn;
      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        _user = user;
      }
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/data/models/profil/profil_model.dart';
import 'package:inventaris_app/data/repositories/profil_repository.dart';

class ProfilViewModel extends ChangeNotifier {
  final ProfilRepository repository;

  const ProfilViewModel({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  ProfilModel? _profil;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfilModel? get profil => _profil;

  Future<void> loadProfil() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _profil = await repository.getProfil();
      _isLoading = false;
      notifyListeners();
    } on ServerFailure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat profil';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfil(ProfilModel profil) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _profil = await repository.updateProfil(profil);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ServerFailure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan profil';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

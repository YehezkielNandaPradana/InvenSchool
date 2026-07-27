import 'package:flutter/foundation.dart';
import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/data/models/barang_masuk/barang_masuk_model.dart';
import 'package:inventaris_app/data/repositories/barang_masuk_repository.dart';

class BarangMasukViewModel extends ChangeNotifier {
  final BarangMasukRepository repository;

  BarangMasukViewModel({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  List<BarangMasukModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BarangMasukModel> get items => _items;

  Future<void> loadItems() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _items = await repository.getBarangMasuk();
      _isLoading = false;
      notifyListeners();
    } on ServerFailure catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data';
      _isLoading = false;
      notifyListeners();
    }
  }
}

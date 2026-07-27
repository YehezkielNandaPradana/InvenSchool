import 'package:flutter/foundation.dart';
import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/data/models/data_rekap/data_rekap_model.dart';
import 'package:inventaris_app/data/repositories/data_rekap_repository.dart';

class DataRekapViewModel extends ChangeNotifier {
  final DataRekapRepository repository;

  DataRekapViewModel({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  List<DataRekapModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DataRekapModel> get items => _items;

  Future<void> loadItems() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _items = await repository.getDataRekap();
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

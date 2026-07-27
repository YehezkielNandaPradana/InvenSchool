import 'package:flutter/foundation.dart';
import 'package:inventaris_app/core/error/failures.dart';
import 'package:inventaris_app/data/models/kondisi_rusak/kondisi_rusak_model.dart';
import 'package:inventaris_app/data/repositories/kondisi_rusak_repository.dart';

class KondisiRusakViewModel extends ChangeNotifier {
  final KondisiRusakRepository repository;

  KondisiRusakViewModel({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  List<KondisiRusakModel> _items = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<KondisiRusakModel> get items => _items;

  Future<void> loadItems() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _items = await repository.getKondisiRusak();
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

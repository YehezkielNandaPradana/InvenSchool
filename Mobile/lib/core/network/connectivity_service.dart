import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity connectivity = Connectivity();

  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void onConnectivityChanged(void Function(List<ConnectivityResult>) onChanged) {
    _subscription = connectivity.onConnectivityChanged.listen(onChanged);
  }

  void dispose() {
    _subscription?.cancel();
  }
}

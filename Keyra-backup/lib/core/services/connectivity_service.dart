import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final Connectivity _connectivity = Connectivity();
  
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();
  
  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  Stream<ConnectivityResult> get onConnectivityChanged => 
    _connectivity.onConnectivityChanged;
}

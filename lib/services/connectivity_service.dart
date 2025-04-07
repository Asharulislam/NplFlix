

import 'package:connectivity/connectivity.dart';

import '../enums/connectivity_status_enum.dart';

class ConnectivityService {
  static late final ConnectivityService instance;

  ConnectivityService._();

  static final ConnectivityService _singleton = ConnectivityService._();

  static ConnectivityService get connectivityInstance => _singleton;


  // Check Connectivity
  Future<bool> isConnected() async {
    var result = await Connectivity().checkConnectivity();
    return getBooleanStatusFromResult(getStatusFromResult(result));
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.offline;
      default:
        return ConnectivityStatus.offline;
    }
  }

  bool getBooleanStatusFromResult(ConnectivityStatus result) {
    switch (result) {
      case ConnectivityStatus.cellular:
        return true;
      case ConnectivityStatus.wifi:
        return true;
      case ConnectivityStatus.offline:
        return false;
      default:
        return false;
    }
  }
}

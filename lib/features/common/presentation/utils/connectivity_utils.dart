import 'package:flutter/material.dart';
import '../../../../core/services/connectivity_service.dart';
import '../widgets/no_internet_dialog.dart';

class ConnectivityUtils {
  static Future<bool> checkConnectivity(BuildContext context) async {
    if (!await ConnectivityService().hasConnection()) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => const NoInternetDialog(),
        );
      }
      return false;
    }
    return true;
  }
}

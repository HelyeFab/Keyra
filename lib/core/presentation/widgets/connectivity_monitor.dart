import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/connectivity_bloc.dart';
import '../../../features/common/presentation/widgets/no_internet_dialog.dart';

class ConnectivityMonitor extends StatelessWidget {
  final Widget child;

  const ConnectivityMonitor({
    super.key,
    required this.child,
  });

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const NoInternetDialog(),
    );
  }

  void _hideNoInternetDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) =>
          previous.isConnected != current.isConnected ||
          (!previous.hasCheckedInitially && current.hasCheckedInitially),
      listener: (context, state) {
        if (!state.isConnected && state.hasCheckedInitially) {
          // Only show dialog if we've done initial check and lost connection
          _showNoInternetDialog(context);
        } else if (state.isConnected && ModalRoute.of(context)?.isCurrent == false) {
          // Only pop dialog if we're showing it (not on first route)
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: child,
    );
  }
}

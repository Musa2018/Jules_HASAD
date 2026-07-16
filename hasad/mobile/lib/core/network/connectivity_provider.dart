import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final connectivityStatusProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return ref.watch(_connectivityProvider).onConnectivityChanged;
});

extension ConnectivityX on WidgetRef {
  bool get isOffline {
    final connectivity = watch(connectivityStatusProvider).value ?? [];
    return connectivity.isEmpty || connectivity.contains(ConnectivityResult.none);
  }
}

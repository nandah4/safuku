import 'dart:async';
import 'package:get/get.dart';

/// Events that can be emitted across controllers.
enum AppEvent { walletChanged, transactionChanged, categoryChanged }

class AppEventBus extends GetxService {
  final _controller = StreamController<AppEvent>.broadcast();

  /// Subscribe to a specific event type. Returns the [StreamSubscription]
  StreamSubscription<AppEvent> on(
    AppEvent event,
    void Function(AppEvent) callback,
  ) {
    return _controller.stream.where((e) => e == event).listen(callback);
  }

  /// Emit an event to all listeners.
  void emit(AppEvent event) => _controller.add(event);

  @override
  void onClose() {
    _controller.close();
    super.onClose();
  }
}

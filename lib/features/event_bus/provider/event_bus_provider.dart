import 'package:oyt_admin/features/event_bus/provider/event_bus_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/enums/event_bus_enum.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';

final eventBusProvider =
    StateNotifierProvider<EventBusProvider, EventBusState>(EventBusProvider.fromRef);

class EventBusProvider extends StateNotifier<EventBusState> {
  EventBusProvider({required this.ref, required this.socketIOHandler})
      : super((const EventBusState()));

  factory EventBusProvider.fromRef(Ref ref) {
    final socketIo = ref.read(socketProvider);
    return EventBusProvider(ref: ref, socketIOHandler: socketIo);
  }

  final Ref ref;
  final SocketIOHandler socketIOHandler;

  void startListening() {
    socketIOHandler.onMap(SocketConstants.eventBus, (data) {
      final rawEventName = data['eventName'];
      if (rawEventName is! String) return;
      final eventName = EventBusEvents.fromValue(rawEventName);
      switch (eventName) {
        case EventBusEvents.menuUpdated:
          ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
          break;
        default:
          Logger.log('EventBusProvider: Event not found: $eventName');
      }
    });
  }
}

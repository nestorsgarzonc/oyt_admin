import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_admin/features/orders_queue/orders_queue_state.dart';
import 'package:oyt_front_orders_queue/models/orders_queue.dart';

final ordersQueueProvider = StateNotifierProvider<OrdersQueueNotifier, OrdersQueueState>((ref) {
  return OrdersQueueNotifier.fromRef(ref);
});

class OrdersQueueNotifier extends StateNotifier<OrdersQueueState> {
  OrdersQueueNotifier(this.ref, this.socketIOHandler) : super(OrdersQueueState.initial());

  factory OrdersQueueNotifier.fromRef(Ref ref) {
    final socketIo = ref.read(socketProvider);
    return OrdersQueueNotifier(ref, socketIo);
  }

  final Ref ref;
  final SocketIOHandler socketIOHandler;

  void startListeningSocket() {
    socketIOHandler.onMap(SocketConstants.orderQueue, (data) {
      try {
        final orders = List.from(data['orders']).map((e) => OrdersQueueModel.fromMap(e)).toList();
        state = state.copyWith(ordersQueue: StateAsync.success(orders));
      } catch (e) {
        state = state.copyWith(ordersQueue: StateAsync.error(Failure(e.toString())));
      }
    });
  }
}

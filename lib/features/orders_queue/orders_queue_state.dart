import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_orders_queue/models/orders_queue.dart';

class OrdersQueueState extends Equatable {
  factory OrdersQueueState.initial() => OrdersQueueState(StateAsync.initial());

  const OrdersQueueState(this.ordersQueue);
  final StateAsync<List<OrdersQueueModel>> ordersQueue;

  @override
  List<Object?> get props => [ordersQueue];

  OrdersQueueState copyWith({
    StateAsync<List<OrdersQueueModel>>? ordersQueue,
  }) {
    return OrdersQueueState(
      ordersQueue ?? this.ordersQueue,
    );
  }
}

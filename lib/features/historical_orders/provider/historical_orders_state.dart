import 'package:equatable/equatable.dart';
import 'package:oyt_admin/features/historical_orders/model/historical_orders_model.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';

class HistoricalOrdersState extends Equatable {
  const HistoricalOrdersState({required this.historicalOrders});

  final StateAsync<HistoricalOrders> historicalOrders;
  @override
  List<Object?> get props => [historicalOrders];

  HistoricalOrdersState copyWith({
    StateAsync<HistoricalOrders>? historicalOrders,
  }) {
    return HistoricalOrdersState(
      historicalOrders: historicalOrders ?? this.historicalOrders,
    );
  }
}

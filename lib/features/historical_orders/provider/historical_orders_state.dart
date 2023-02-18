import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';
import 'package:oyt_admin/features/historical_orders/model/historical_orders_model.dart';

class HistoricalOrdersState extends Equatable {
  const HistoricalOrdersState({
    required this.historicalOrders,
    this.historicalOrdersFilter,
    this.isFetchingMore = false,
    this.isThereNextPage = true,
  });

  factory HistoricalOrdersState.initial() {
    return HistoricalOrdersState(historicalOrders: StateAsync.initial());
  }

  final StateAsync<HistoricalOrders> historicalOrders;
  final HistoricalOrdersFilter? historicalOrdersFilter;
  final bool isFetchingMore;
  final bool isThereNextPage;

  @override
  List<Object?> get props => [historicalOrders, historicalOrdersFilter, isFetchingMore];

  HistoricalOrdersState copyWith({
    StateAsync<HistoricalOrders>? historicalOrders,
    HistoricalOrdersFilter? historicalOrdersFilter,
    bool? isFetchingMore,
    bool? isThereNextPage,
  }) {
    return HistoricalOrdersState(
      historicalOrders: historicalOrders ?? this.historicalOrders,
      historicalOrdersFilter: historicalOrdersFilter ?? this.historicalOrdersFilter,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isThereNextPage: isThereNextPage ?? this.isThereNextPage,
    );
  }
}

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:oyt_admin/features/historical_orders/model/historical_order_response.dart';
import 'package:oyt_front_order/models/orders_model.dart';

class HistoricalOrders extends Equatable {
  const HistoricalOrders({required this.orders, required this.isThereNextPage});

  factory HistoricalOrders.fromList(List list) {
    return HistoricalOrders(
      orders: List<HistoricalOrdersResponse>.from(list.map((x) => Order.fromMap(x))),
      isThereNextPage: true,
    );
  }

  factory HistoricalOrders.fromMap(Map<String, dynamic> rawMap) {
    return HistoricalOrders(
      orders: List<HistoricalOrdersResponse>.from((rawMap['orderPaged'] as List).map((e) => HistoricalOrdersResponse.fromMap(e))),
      isThereNextPage: (rawMap['nextPage'] as bool),
    );
  }

  HistoricalOrders addMore(HistoricalOrders newElements) {
    return copyWith(
      orders: [...orders, ...newElements.orders],
    );
  }

  final List<HistoricalOrdersResponse> orders;
  final bool isThereNextPage;

  HistoricalOrders copyWith({
    List<HistoricalOrdersResponse>? orders,
    bool? isThereNextPage,
  }) {
    return HistoricalOrders(
      orders: orders ?? this.orders,
      isThereNextPage: isThereNextPage ?? this.isThereNextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orders': orders.map((x) => x.toMap()).toList(),
      'nextPage': isThereNextPage,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Orders(orders: $orders)';

  @override
  List<Object> get props => [orders, isThereNextPage];
}

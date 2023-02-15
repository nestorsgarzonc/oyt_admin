import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:oyt_front_order/models/orders_model.dart';

class HistoricalOrders extends Equatable {
  const HistoricalOrders({required this.orders});

  factory HistoricalOrders.fromList(List list) {
    return HistoricalOrders(
      orders: List<Order>.from(list.map((x) => Order.fromMap(x))),
    );
  }

  factory HistoricalOrders.fromMap(Map<String, dynamic> rawMap) {
    final Map map = rawMap['historicalOrders'];
    return HistoricalOrders(
      orders: map['orders'] as List<Order>,
    );
  }

  HistoricalOrders addMore(HistoricalOrders newElements) {
    return copyWith(
      orders: [...orders, ...newElements.orders],
    );
  }

  final List<Order> orders;

  HistoricalOrders copyWith({
    List<Order>? orders,
  }) {
    return HistoricalOrders(
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orders': orders.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Orders(orders: $orders)';

  @override
  List<Object> get props => [orders];
}
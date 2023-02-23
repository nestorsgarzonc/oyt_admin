import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:oyt_front_order/models/order_complete_response.dart';

class HistoricalOrdersResponse extends Equatable {
  const HistoricalOrdersResponse({
    required this.id, 
    required this.usersOrder, 
    required this.tableId, 
    required this.totalPrice, 
    required this.restaurantId, 
    required this.tip, 
    required this.paymentWay, 
    required this.paymentMethod, 
    required this.createdAt, 
    required this.updatedAt,
  });

  factory HistoricalOrdersResponse.fromMap(Map<String, dynamic> map) {
    return HistoricalOrdersResponse(
      id: map['_id'],
      usersOrder: List<String>.from(map['usersOrder']), 
      tableId: map['tableId'], 
      totalPrice: map['totalPrice'], 
      restaurantId: map['restaurantId'], 
      tip: map['tip'],
      paymentWay: map['paymentWay'],
      paymentMethod: map['paymentMethod'], 
      createdAt: DateTime.parse(map['createdAt']), 
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  final String id;
  final List<String> usersOrder;
  final String tableId;
  final int totalPrice;
  final String restaurantId;
  final int tip;
  final String paymentWay;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usersOrder': usersOrder,
      'totalPrice': totalPrice,
      'restaurantId': restaurantId,
      'tip': tip,
      'paymentWay': paymentWay,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object> get props {
    return [
      id,
      usersOrder,
      tableId,
      totalPrice,
      restaurantId,
      tip,
      paymentWay,
      paymentMethod,
      createdAt,
      updatedAt,
    ];
  }
}
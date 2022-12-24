import 'dart:convert';

import 'package:equatable/equatable.dart';

class CheckAdminResponse extends Equatable {
  factory CheckAdminResponse.fromJson(String source) =>
      CheckAdminResponse.fromMap(json.decode(source));

  factory CheckAdminResponse.fromMap(Map<String, dynamic> map) {
    return CheckAdminResponse(
      restaurantId: map['restaurantId'] ?? '',
    );
  }
  const CheckAdminResponse({
    required this.restaurantId,
  });

  final String restaurantId;

  CheckAdminResponse copyWith({
    String? restaurantId,
  }) {
    return CheckAdminResponse(
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'CheckAdminResponse(restaurantId: $restaurantId)';

  @override
  List<Object> get props => [restaurantId];
}

import 'package:oyt_front_restaurant/models/base_restaurant_entity.dart';

class Waiter extends BaseRestaurantEntity {
  const Waiter({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.isAvailable,
    required super.restaurantId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory Waiter.fromMap(Map<String, dynamic> map) {
    return Waiter(
      id: map['_id'] as String,
      firstName: map['user']['firstName'] as String,
      lastName: map['user']['lastName'] as String,
      email: map['user']['email'] as String,
      isAvailable: map['isAvailable'] as bool,
      restaurantId: map['restaurant'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  @override
  Waiter copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    bool? isAvailable,
    String? restaurantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Waiter(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isAvailable: isAvailable ?? this.isAvailable,
      restaurantId: restaurantId ?? this.restaurantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

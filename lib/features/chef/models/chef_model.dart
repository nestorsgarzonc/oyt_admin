import 'package:oyt_front_restaurant/models/base_restaurant_entity.dart';

class Chef extends BaseRestaurantEntity {
  const Chef({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.isAvailable,
    required super.restaurantId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory Chef.fromMap(Map<String, dynamic> map) {
    return Chef(
      id: map['_id'] as int,
      firstName: map['user']['firstName'] as String,
      lastName: map['user']['lastName'] as String,
      email: map['user']['email'] as String,
      isAvailable: map['isAvailable'] as bool,
      restaurantId: map['restaurant'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

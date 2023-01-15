import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';

class RestaurantState extends Equatable {
  const RestaurantState({required this.restaurant});

  final StateAsync<RestaurantModel> restaurant;
  @override
  List<Object?> get props => [restaurant];

  RestaurantState copyWith({
    StateAsync<RestaurantModel>? restaurant,
  }) {
    return RestaurantState(
      restaurant: restaurant ?? this.restaurant,
    );
  }
}

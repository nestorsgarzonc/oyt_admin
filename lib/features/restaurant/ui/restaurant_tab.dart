import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_admin/features/restaurant/ui/restaurant_body.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';

class RestaurantTab extends ConsumerWidget {
  const RestaurantTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantState = ref.watch(restaurantProvider);
    return restaurantState.restaurant.on(
      onError: (error) => Text(error.toString()),
      onLoading: () => const ScreenLoadingWidget(),
      onInitial: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(restaurantProvider.notifier).getRestaurant();
        });
        return const ScreenLoadingWidget();
      },
      onData: (restaurant) => RestaurantBody(
        restaurant: restaurant,
        onRestaurantChanged: (value) {
          //TODO: IMPLEMENT onRestaurantChanged
        },
      ),
    );
  }
}

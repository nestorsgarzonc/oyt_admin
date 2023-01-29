import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_admin/features/restaurant/ui/restaurant_body.dart';

class RegisterRestaurant extends ConsumerWidget {
  const RegisterRestaurant({super.key});

  static const route = '/register-restaurant';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registra tu restaurante')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RestaurantBody(
          restaurant: null,
          onRestaurantChanged: ref.read(restaurantProvider.notifier).createRestaurant,
        ),
      ),
    );
  }
}

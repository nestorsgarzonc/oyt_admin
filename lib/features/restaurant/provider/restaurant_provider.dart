import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/auth/provider/auth_provider.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_state.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_restaurant/models/restaurant_creation_model.dart';
import 'package:oyt_front_restaurant/repositories/restaurant_repository.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';

final restaurantProvider = StateNotifierProvider<RestaurantProvider, RestaurantState>((ref) {
  return RestaurantProvider.fromRead(ref);
});

class RestaurantProvider extends StateNotifier<RestaurantState> {
  RestaurantProvider({required this.restaurantRepository, required this.ref})
      : super(RestaurantState(restaurant: StateAsync.initial()));

  factory RestaurantProvider.fromRead(Ref ref) {
    return RestaurantProvider(
      restaurantRepository: ref.read(restaurantRepositoryProvider),
      ref: ref,
    );
  }

  final Ref ref;
  final RestaurantRepository restaurantRepository;

  Future<void> getRestaurant({bool silent = false}) async {
    if (!silent) state = state.copyWith(restaurant: StateAsync.loading());
    final result = await restaurantRepository.getMenuByRestaurant();
    result.fold(
      (failure) => state = state.copyWith(restaurant: StateAsync.error(failure)),
      (restaurant) {
        if (restaurant.primaryColor != null) {
          ref.read(themeProvider.notifier).changeSeedColor(restaurant.primaryColor!);
        }
        state = state.copyWith(restaurant: StateAsync.success(restaurant));
      },
    );
  }

  Future<void> updateRestaurant(RestaurantCreationModel restaurant) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await restaurantRepository.updateRestaurant(restaurant);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (failure != null) {
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': failure.message});
      return;
    }
    getRestaurant(silent: true);
  }

  Future<void> createRestaurant(RestaurantCreationModel restaurant) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await restaurantRepository.createRestaurant(restaurant);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (failure != null) {
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': failure.message});
      return;
    }
    ref.read(authProvider.notifier).checkIfIsAdmin();
  }

  Future<void> updateRestaurantLogo(Uint8List logo) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await restaurantRepository.updateRestaurantLogo(logo);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (failure != null) {
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': failure.message});
      return;
    }
    getRestaurant(silent: true);
  }

  Future<void> updateRestaurantImage(Uint8List image) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await restaurantRepository.updateRestaurantImage(image);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (failure != null) {
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': failure.message});
      return;
    }
    getRestaurant(silent: true);
  }
}

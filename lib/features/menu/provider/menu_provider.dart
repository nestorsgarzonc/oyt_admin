import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/menu/provider/menu_state.dart';
import 'package:oyt_admin/features/menu/repositories/menu_repository.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';
import 'package:riverpod/riverpod.dart';

final menuProvider = StateNotifierProvider<MenuProvider, MenuState>(MenuProvider.fromRef);

class MenuProvider extends StateNotifier<MenuState> {
  MenuProvider(this.repository, this.ref) : super(MenuState.initial());

  factory MenuProvider.fromRef(Ref ref) {
    final repository = ref.read(menuRepositoryProvider);
    return MenuProvider(repository, ref);
  }

  final MenuRepository repository;
  final Ref ref;

  Future<void> addCategory(Menu category) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await repository.createCategory(category);
    if (failure != null) {
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, failure.message);
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Categoria creada correctamente');
  }

  Future<void> updateCategory(Menu category) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await repository.updateCategory(category);
    if (failure != null) {
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, failure.message);
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
        ref.read(routerProvider).context, 'Categoria actualizada correctamente');
  }

  Future<void> addMenuItem(Menu category, MenuItem menuItem) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await repository.createMenuItem(category, menuItem);
    if (failure != null) {
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, failure.message);
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Categoria creada correctamente');
  }

  Future<void> updateMenuItem(MenuItem menuItem) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await repository.updateMenuItem(menuItem);
    if (failure != null) {
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, failure.message);
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
        ref.read(routerProvider).context, 'Categoria actualizada correctamente');
  }
}

import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/menu/provider/menu_state.dart';
import 'package:oyt_front_menu/repositories/menu_repository.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_product/models/product_model.dart';
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

  Future<void> updateCategory(Menu category, bool toggleAviability) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failures = await Future.wait([
      repository.updateCategory(category),
      repository.toggleCategoryAviability(category),
    ]);
    if (!failures.contains(null)) {
      final failure = failures.firstWhere((element) => element == null);
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(
        ref.read(routerProvider).context,
        failure?.message ?? 'Ha ocurrido un error',
      );
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      'Categoria actualizada correctamente',
    );
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
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Item creado correctamente');
  }

  Future<void> updateMenuItem(MenuItem menuItem, bool toggleAviability) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failures = await Future.wait([
      repository.updateMenuItem(menuItem),
      repository.toggleMenuItemAviability(menuItem),
    ]);
    if (!failures.contains(null)) {
      final failure = failures.firstWhere((element) => element == null);
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(
        ref.read(routerProvider).context,
        failure?.message ?? 'Ha ocurrido un error',
      );
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      'Item actualizado correctamente',
    );
  }

  Future<void> addTopping(MenuItem menuItem, Topping topping) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await repository.addTopping(menuItem, topping);
    if (failure != null) {
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, failure.message);
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Topping creado correctamente');
  }

  Future<void> updateTopping(Topping topping, bool toggleAviability) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failures = await Future.wait([
      repository.updateTopping(topping),
      repository.toggleToppingAviability(topping),
    ]);
    if (!failures.contains(null)) {
      final failure = failures.firstWhere((element) => element == null);
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(
        ref.read(routerProvider).context,
        failure?.message ?? 'Ha ocurrido un error',
      );
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      'Topping actualizado correctamente',
    );
  }

  Future<void> addToppingOption(Topping topping, ToppingOption toppingOption) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failure = await repository.addToppingOption(topping, toppingOption);
    if (failure != null) {
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, failure.message);
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      'Topping item creado correctamente',
    );
  }

  Future<void> updateToppingOption(ToppingOption toppingOption, bool toggleAviability) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    final failures = await Future.wait([
      repository.updateToppingOption(toppingOption),
      repository.toggleToppingOptionAviability(toppingOption),
    ]);
    if (!failures.contains(null)) {
      final failure = failures.firstWhere((element) => element == null);
      ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
      CustomSnackbar.showSnackBar(
        ref.read(routerProvider).context,
        failure?.message ?? 'Ha ocurrido un error',
      );
      return;
    }
    await ref.read(restaurantProvider.notifier).getRestaurant(silent: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      'Topping item actualizado correctamente',
    );
  }
}

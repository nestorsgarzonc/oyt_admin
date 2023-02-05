import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuDatasourceProvider = Provider<MenuDataSource>(MenuDataSourceImpl.fromRef);

abstract class MenuDataSource {
  Future<void> createCategory(Menu category);
  Future<void> updateCategory(Menu category);
  Future<void> createMenuItem(Menu category, MenuItem menuItem);
  Future<void> updateMenuItem(MenuItem menuItem);
  Future<void> addTopping(MenuItem menuItem, Topping topping);
  Future<void> updateTopping(Topping topping);
  Future<void> addToppingOption(Topping topping, Option toppingOption);
  Future<void> updateToppingOption(Option toppingOption);
}

class MenuDataSourceImpl implements MenuDataSource {
  MenuDataSourceImpl(this.apiHandler);

  factory MenuDataSourceImpl.fromRef(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    return MenuDataSourceImpl(apiHandler);
  }

  final ApiHandler apiHandler;

  @override
  Future<void> createCategory(Menu category) async {
    try {
      await apiHandler.post(
        '/menu/category',
        category.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(Menu category) async {
    try {
      await apiHandler.put(
        '/menu/category/${category.id}',
        category.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> createMenuItem(Menu category, MenuItem menuItem) async {
    try {
      await apiHandler.post(
        '/menu/item/${category.id}',
        menuItem.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> updateMenuItem(MenuItem menuItem) async {
    try {
      await apiHandler.put(
        '/menu/item/${menuItem.id}',
        menuItem.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> addTopping(MenuItem menuItem, Topping topping) async {
    try {
      await apiHandler.post(
        '/menu/toppings/${menuItem.id}',
        topping.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> updateTopping(Topping topping) async {
    try {
      await apiHandler.put(
        '/menu/toppings/${topping.id}',
        topping.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> addToppingOption(Topping topping, Option toppingOption) async {
    try {
      await apiHandler.post(
        '/menu/option/${topping.id}',
        toppingOption.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> updateToppingOption(Option toppingOption) async {
    try {
      await apiHandler.put(
        '/menu/option/${toppingOption.id}',
        toppingOption.toMapCRUD(),
      );
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}

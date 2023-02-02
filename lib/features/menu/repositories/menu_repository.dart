import 'package:oyt_admin/features/menu/data_source/menu_data_source.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuRepositoryProvider = Provider<MenuRepository>(MenuRepositoryImpl.fromRef);

abstract class MenuRepository {
  Future<Failure?> createCategory(Menu category);
  Future<Failure?> updateCategory(Menu category);
  Future<Failure?> createMenuItem(Menu category, MenuItem menuItem);
  Future<Failure?> updateMenuItem(MenuItem menuItem);
}

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(this.dataSource);

  factory MenuRepositoryImpl.fromRef(Ref ref) {
    final dataSource = ref.read(menuDatasourceProvider);
    return MenuRepositoryImpl(dataSource);
  }

  final MenuDataSource dataSource;

  @override
  Future<Failure?> createCategory(Menu category) async {
    try {
      await dataSource.createCategory(category);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Failure?> updateCategory(Menu category) async {
    try {
      await dataSource.updateCategory(category);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Failure?> createMenuItem(Menu category, MenuItem menuItem) async {
    try {
      await dataSource.createMenuItem(category, menuItem);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Failure?> updateMenuItem(MenuItem menuItem) async {
    try {
      await dataSource.updateMenuItem(menuItem);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

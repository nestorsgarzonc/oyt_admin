import 'package:oyt_admin/features/chef/models/chef_dto.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/logger/logger.dart';

final chefDatasourceProvider = Provider<ChefDataSource>(ChefDataSourceImpl.fromRef);

abstract class ChefDataSource {
  Future<List<Chef>> getChefs();
  Future<void> addChef(ChefDto chef);
  Future<void> updateChef(Chef chef);
}

class ChefDataSourceImpl implements ChefDataSource {
  ChefDataSourceImpl(this.apiHandler);

  factory ChefDataSourceImpl.fromRef(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    return ChefDataSourceImpl(apiHandler);
  }

  final ApiHandler apiHandler;

  @override
  Future<void> addChef(ChefDto chef) async {
    try {
      await apiHandler.post('/chef', chef.toMap());
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<List<Chef>> getChefs() async {
    try {
      final res = await apiHandler.get('/chef');
      return res.responseList!.map((e) => Chef.fromMap(e)).toList();
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> updateChef(Chef chef) async {
    try {
      await apiHandler.put('/chef/${chef.id}', {
        'isAvailable': chef.isAvailable,
      });
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}

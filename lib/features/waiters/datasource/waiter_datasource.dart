import 'package:oyt_admin/features/waiters/models/waiter_dto.dart';
import 'package:oyt_admin/features/waiters/models/waiter_model.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/logger/logger.dart';

final waiterDatasourceProvider = Provider<WaiterDataSource>(WaiterDataSourceImpl.fromRef);

abstract class WaiterDataSource {
  Future<List<Waiter>> getWaiters();
  Future<void> addWaiter(WaiterDto waiter);
  Future<void> updateWaiter(Waiter waiter);
}

class WaiterDataSourceImpl implements WaiterDataSource {
  WaiterDataSourceImpl(this.apiHandler);

  factory WaiterDataSourceImpl.fromRef(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    return WaiterDataSourceImpl(apiHandler);
  }

  final ApiHandler apiHandler;

  @override
  Future<void> addWaiter(WaiterDto waiter) async {
    try {
      await apiHandler.post('/waiter', waiter.toMap());
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<List<Waiter>> getWaiters() async {
    try {
      final res = await apiHandler.get('/waiter');
      return res.responseList!.map((e) => Waiter.fromMap(e)).toList();
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> updateWaiter(Waiter waiter) async {
    try {
      await apiHandler.put('/waiter/${waiter.id}', {
        'isAvailable': waiter.isAvailable,
      });
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}

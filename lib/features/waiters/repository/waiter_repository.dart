import 'package:oyt_admin/features/waiters/datasource/waiter_datasource.dart';
import 'package:oyt_admin/features/waiters/models/waiter_dto.dart';
import 'package:oyt_admin/features/waiters/models/waiter_model.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final waiterRepositoryProvider = Provider<WaiterRepository>(WaiterRepositoryImpl.fromRef);

abstract class WaiterRepository {
  Future<Either<Failure, List<Waiter>>> getWaiters();
  Future<Failure?> addWaiter(WaiterDto waiter);
}

class WaiterRepositoryImpl implements WaiterRepository {
  WaiterRepositoryImpl(this.waiterDataSource);

  factory WaiterRepositoryImpl.fromRef(Ref ref) {
    final waiterDataSource = ref.read(waiterDatasourceProvider);
    return WaiterRepositoryImpl(waiterDataSource);
  }

  final WaiterDataSource waiterDataSource;

  @override
  Future<Either<Failure, List<Waiter>>> getWaiters() async {
    try {
      final res = await waiterDataSource.getWaiters();
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Failure?> addWaiter(WaiterDto waiter) async {
    try {
      await waiterDataSource.addWaiter(waiter);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

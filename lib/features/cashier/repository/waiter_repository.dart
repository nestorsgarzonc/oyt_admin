import 'package:oyt_admin/features/cashier/datasource/cashier_datasource.dart';
import 'package:oyt_admin/features/cashier/models/cashier_dto.dart';
import 'package:oyt_admin/features/cashier/models/cashier_model.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final cashierRepositoryProvider = Provider<CashierRepository>(CashierRepositoryImpl.fromRef);

abstract class CashierRepository {
  Future<Either<Failure, List<Cashier>>> getCashiers();
  Future<Failure?> addCashier(CashierDto cashier);
  Future<Failure?> updateCashier(Cashier cashier);
}

class CashierRepositoryImpl implements CashierRepository {
  CashierRepositoryImpl(this.cashierDataSource);

  factory CashierRepositoryImpl.fromRef(Ref ref) {
    final cashierDataSource = ref.read(cashierDatasourceProvider);
    return CashierRepositoryImpl(cashierDataSource);
  }

  final CashierDataSource cashierDataSource;

  @override
  Future<Either<Failure, List<Cashier>>> getCashiers() async {
    try {
      final res = await cashierDataSource.getCashiers();
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Failure?> addCashier(CashierDto cashier) async {
    try {
      await cashierDataSource.addCashier(cashier);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
  
  @override
  Future<Failure?> updateCashier(Cashier cashier) async{
    try {
      await cashierDataSource.updateCashier(cashier);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

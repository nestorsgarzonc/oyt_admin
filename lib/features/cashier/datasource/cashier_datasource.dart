import 'package:oyt_admin/features/cashier/models/cashier_dto.dart';
import 'package:oyt_admin/features/cashier/models/cashier_model.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/logger/logger.dart';

final cashierDatasourceProvider = Provider<CashierDataSource>(CashierDataSourceImpl.fromRef);

abstract class CashierDataSource {
  Future<List<Cashier>> getCashiers();
  Future<void> addCashier(CashierDto cashier);
}

class CashierDataSourceImpl implements CashierDataSource {
  CashierDataSourceImpl(this.apiHandler);

  factory CashierDataSourceImpl.fromRef(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    return CashierDataSourceImpl(apiHandler);
  }

  final ApiHandler apiHandler;

  @override
  Future<void> addCashier(CashierDto cashier) async {
    try {
      await apiHandler.post('/cashier', cashier.toMap());
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<List<Cashier>> getCashiers() async {
    try {
      final res = await apiHandler.get('/cashier');
      return res.responseList!.map((e) => Cashier.fromMap(e)).toList();
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}

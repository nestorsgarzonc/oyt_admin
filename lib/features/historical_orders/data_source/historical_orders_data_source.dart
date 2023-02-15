import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_admin/features/historical_orders/model/historical_orders_model.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';

final historicalOrdersDataSourceProvider = Provider<HistoricalOrdersDataSource>((ref) {
  return HistoricalOrdersDataSourceImpl.fromRead(ref);
});

abstract class HistoricalOrdersDataSource {
  Future<HistoricalOrders> postHistoricalOrders(HistoricalOrdersFilter? historicalOrdersFilter);
}

class HistoricalOrdersDataSourceImpl implements HistoricalOrdersDataSource {
  HistoricalOrdersDataSourceImpl(this.apiHandler);

  factory HistoricalOrdersDataSourceImpl.fromRead(Ref ref) {
    return HistoricalOrdersDataSourceImpl(ref.read(apiHandlerProvider));
  }

  final ApiHandler apiHandler;

  @override
  Future<HistoricalOrders> postHistoricalOrders(HistoricalOrdersFilter? historicalOrdersFilter) async {
    final Map<String, dynamic> dataForFilter = historicalOrdersFilter == null ? {} : historicalOrdersFilter.toMap();
    try {
      final res = await apiHandler.post(
        'api/order/order-history',
         dataForFilter,
      );
      Logger.log(res.toString());
      return HistoricalOrders.fromMap(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
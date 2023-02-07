import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_admin/features/historical_orders/model/historical_orders_model.dart';

final historicalOrdersDataSourceProvider = Provider<HistoricalOrdersDataSource>((ref) {
  return HistoricalOrdersDataSourceImpl.fromRead(ref);
});

abstract class HistoricalOrdersDataSource {
  Future<HistoricalOrders> getHistoricalOrders();
}

class HistoricalOrdersDataSourceImpl implements HistoricalOrdersDataSource {
  HistoricalOrdersDataSourceImpl(this.apiHandler);

  factory HistoricalOrdersDataSourceImpl.fromRead(Ref ref) {
    return HistoricalOrdersDataSourceImpl(ref.read(apiHandlerProvider));
  }

  final ApiHandler apiHandler;

  @override
  Future<HistoricalOrders> getHistoricalOrders() async {
    try {
      //pasar restaurantId en los headers
      final res = await apiHandler.get('');
      return HistoricalOrders.fromMap(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_admin/features/historical_orders/data_source/historical_orders_data_source.dart';
import 'package:oyt_admin/features/historical_orders/model/historical_orders_model.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';

final historicalOrdersRepositoryProvider = Provider<HistoricalOrdersRepository>((ref) {
  return HistoricalOrdersRepositoryImpl.fromRead(ref);
});

abstract class HistoricalOrdersRepository {
  Future<Either<Failure, HistoricalOrders>> postHistoricalOrders(HistoricalOrdersFilter? historicalOrdersFilter);
}

class HistoricalOrdersRepositoryImpl implements HistoricalOrdersRepository {
  HistoricalOrdersRepositoryImpl({required this.dataSource});

  factory HistoricalOrdersRepositoryImpl.fromRead(Ref ref) {
    return HistoricalOrdersRepositoryImpl(dataSource: ref.read(historicalOrdersDataSourceProvider));
  }

  final HistoricalOrdersDataSource dataSource;

   @override
  Future<Either<Failure, HistoricalOrders>> postHistoricalOrders(HistoricalOrdersFilter? historicalOrdersFilter) async {
    try {
      final historricalOrders = await dataSource.postHistoricalOrders(historicalOrdersFilter);
      return Right(historricalOrders);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
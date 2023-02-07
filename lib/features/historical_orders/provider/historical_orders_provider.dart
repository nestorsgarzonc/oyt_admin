import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/historical_orders/provider/historical_orders_state.dart';
import 'package:oyt_admin/features/historical_orders/repository/historical_orders_repository.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';

final historicalOrdersProvider = StateNotifierProvider<HistoricalOrdersProvider, HistoricalOrdersState>((ref) {
  return HistoricalOrdersProvider.fromRead(ref);
});

class HistoricalOrdersProvider extends StateNotifier<HistoricalOrdersState> {
  HistoricalOrdersProvider({required this.historicalOrdersRepository, required this.ref})
      : super(HistoricalOrdersState(historicalOrders: StateAsync.initial()));

  factory HistoricalOrdersProvider.fromRead(Ref ref) {
    return HistoricalOrdersProvider(
      historicalOrdersRepository: ref.read(historicalOrdersRepositoryProvider),
      ref: ref,
    );
  }

  final Ref ref;
  final HistoricalOrdersRepository historicalOrdersRepository;

  Future<void> getHistoricalOrders({bool silent = false}) async {
    if (!silent) state = state.copyWith(historicalOrders: StateAsync.loading());
    final result = await historicalOrdersRepository.getHistoricalOrders();
    result.fold(
      (failure) => state = state.copyWith(historicalOrders: StateAsync.error(failure)),
      (historicalOrders) {
        state = state.copyWith(historicalOrders: StateAsync.success(historicalOrders));
      },
    );
  }
}
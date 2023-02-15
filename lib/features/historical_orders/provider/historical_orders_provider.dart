import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/historical_orders/provider/historical_orders_state.dart';
import 'package:oyt_admin/features/historical_orders/repository/historical_orders_repository.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';

final historicalOrdersProvider =
    StateNotifierProvider<HistoricalOrdersProvider, HistoricalOrdersState>((ref) {
  return HistoricalOrdersProvider.fromRead(ref);
});

class HistoricalOrdersProvider extends StateNotifier<HistoricalOrdersState> {
  HistoricalOrdersProvider({required this.historicalOrdersRepository, required this.ref})
      : super(HistoricalOrdersState.initial());

  factory HistoricalOrdersProvider.fromRead(Ref ref) {
    return HistoricalOrdersProvider(
      historicalOrdersRepository: ref.read(historicalOrdersRepositoryProvider),
      ref: ref,
    );
  }

  final Ref ref;
  final HistoricalOrdersRepository historicalOrdersRepository;

  Future<void> getHistoricalOrders({HistoricalOrdersFilter? historicalOrdersFilter}) async {
    state = state.copyWith(historicalOrders: StateAsync.loading());
    final result = await historicalOrdersRepository.postHistoricalOrders(historicalOrdersFilter);
    result.fold(
      (failure) => state = state.copyWith(historicalOrders: StateAsync.error(failure)),
      (historicalOrders) {
        state = state.copyWith(historicalOrders: StateAsync.success(historicalOrders));
      },
    );
  }

  Future<void> getMoreHistoricalOrders({HistoricalOrdersFilter? historicalOrdersFilter}) async {
    if (state.isFetchingMore) return;
    state = state.copyWith(isFetchingMore: true);
    final result = await historicalOrdersRepository.postHistoricalOrders(historicalOrdersFilter);
    result.fold(
      (failure) => state = state.copyWith(historicalOrders: StateAsync.error(failure)),
      (newHistoricalOrders) {
        final prevState = state.historicalOrders;
        state = state.copyWith(
          historicalOrders: StateAsync.success(
            prevState.data?.addMore(newHistoricalOrders) ?? newHistoricalOrders,
          ),
        );
      },
    );
    state = state.copyWith(isFetchingMore: false);
  }
}

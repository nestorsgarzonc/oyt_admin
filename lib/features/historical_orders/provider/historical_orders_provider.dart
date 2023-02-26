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

  Future<void> getHistoricalOrders({HistoricalOrdersFilter? historicalOrdersFilter, required int pageIndex}) async {
    if (!state.isThereNextPage) return;
    state = state.copyWith(historicalOrders: StateAsync.loading());
    final result = await historicalOrdersRepository.getHistoricalOrders(historicalOrdersFilter, pageIndex);
    result.fold(
      (failure) => state = state.copyWith(historicalOrders: StateAsync.error(failure)),
      (newHistoricalOrders) {
        state = state.copyWith(historicalOrders: StateAsync.success(newHistoricalOrders), isThereNextPage: newHistoricalOrders.isThereNextPage);
      },
    );
  }

  Future<void> getMoreHistoricalOrders({HistoricalOrdersFilter? historicalOrdersFilter, required int pageIndex}) async {
    if (state.isFetchingMore || !state.isThereNextPage) return;
    state = state.copyWith(isFetchingMore: true);
    final result = await historicalOrdersRepository.getHistoricalOrders(historicalOrdersFilter, pageIndex);
    result.fold(
      (failure) => state = state.copyWith(historicalOrders: StateAsync.error(failure)),
      (newHistoricalOrders) {
        final prevState = state.historicalOrders;
        state = state.copyWith(
          historicalOrders: StateAsync.success(
            prevState.data?.addMore(newHistoricalOrders) ?? newHistoricalOrders,
          ),
          isThereNextPage: newHistoricalOrders.isThereNextPage,
        );
      },
    );
    state = state.copyWith(isFetchingMore: false);
  }

  void resetState() {
    state = state.copyWith(isFetchingMore: false, isThereNextPage: true);
  }
}

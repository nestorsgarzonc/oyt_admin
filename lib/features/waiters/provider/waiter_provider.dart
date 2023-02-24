import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/waiters/models/waiter_dto.dart';
import 'package:oyt_admin/features/waiters/models/waiter_model.dart';
import 'package:oyt_admin/features/waiters/provider/waiter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/waiters/repository/waiter_repository.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

final waiterProvider =
    StateNotifierProvider.autoDispose<WaiterNotifier, WaiterState>(WaiterNotifier.fromRef);

class WaiterNotifier extends StateNotifier<WaiterState> {
  WaiterNotifier({required this.ref, required this.waiterRepository})
      : super(WaiterState.initial());

  factory WaiterNotifier.fromRef(Ref ref) {
    final waiterRepository = ref.read(waiterRepositoryProvider);
    return WaiterNotifier(ref: ref, waiterRepository: waiterRepository);
  }

  final Ref ref;
  final WaiterRepository waiterRepository;

  Future<void> getWaiters({bool silence = false}) async {
    if (!silence) state = state.copyWith(waiters: StateAsync.loading());
    final res = await waiterRepository.getWaiters();
    if (!mounted) return;
    res.fold(
      (l) => state = state.copyWith(waiters: StateAsync.error(l)),
      (r) => state = state.copyWith(waiters: StateAsync.success(r)),
    );
  }

  Future<void> createWaiter({required WaiterDto waiter}) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, 'Creando mesero');
    final res = await waiterRepository.addWaiter(waiter);
    getWaiters(silence: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (res != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, res.message);
    }
  }

  Future<void> updateWaiter({required Waiter waiter}) async {
    ref
        .read(dialogsProvider)
        .showLoadingDialog(ref.read(routerProvider).context, 'Actualizando  mesero');
    final res = await waiterRepository.updateWaiter(waiter);
    getWaiters(silence: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (res != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, res.message);
    }
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Mesero actualizado');
  }
}

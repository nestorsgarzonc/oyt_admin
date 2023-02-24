import 'package:oyt_admin/core/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/cashier/models/cashier_dto.dart';
import 'package:oyt_admin/features/cashier/models/cashier_model.dart';
import 'package:oyt_admin/features/cashier/provider/cashier_state.dart';
import 'package:oyt_admin/features/cashier/repository/waiter_repository.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

final cashierProvider =
    StateNotifierProvider.autoDispose<CashierNotifier, CashierState>(CashierNotifier.fromRef);

class CashierNotifier extends StateNotifier<CashierState> {
  CashierNotifier({required this.ref, required this.cashierRepository})
      : super(CashierState.initial());

  factory CashierNotifier.fromRef(Ref ref) {
    final cashierRepository = ref.read(cashierRepositoryProvider);
    return CashierNotifier(ref: ref, cashierRepository: cashierRepository);
  }

  final Ref ref;
  final CashierRepository cashierRepository;

  Future<void> getCashiers({bool silence = false}) async {
    if (!silence) state = state.copyWith(cashiers: StateAsync.loading());
    final res = await cashierRepository.getCashiers();
    if (!mounted) return;
    res.fold(
      (l) => state = state.copyWith(cashiers: StateAsync.error(l)),
      (r) => state = state.copyWith(cashiers: StateAsync.success(r)),
    );
  }

  Future<void> createCashier({required CashierDto cashier}) async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, 'Creando cajero');
    final res = await cashierRepository.addCashier(cashier);
    getCashiers(silence: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (res != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, res.message);
    }
  }

  Future<void> updateCashier({required Cashier cashier}) async {
    ref
        .read(dialogsProvider)
        .showLoadingDialog(ref.read(routerProvider).context, 'Actualizando cajero');
    final res = await cashierRepository.updateCashier(cashier);
    getCashiers(silence: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (res != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, res.message);
    }
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Cajero actualizado');
  }
}

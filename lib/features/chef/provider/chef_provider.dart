import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/chef/models/chef_dto.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';
import 'package:oyt_admin/features/chef/provider/chef_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/chef/repository/chef_repository.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

final chefProvider =
    StateNotifierProvider.autoDispose<ChefNotifier, ChefState>(ChefNotifier.fromRef);

class ChefNotifier extends StateNotifier<ChefState> {
  ChefNotifier({required this.ref, required this.chefRepository}) : super(ChefState.initial());

  factory ChefNotifier.fromRef(Ref ref) {
    final chefRepository = ref.read(chefRepositoryProvider);
    return ChefNotifier(ref: ref, chefRepository: chefRepository);
  }

  final Ref ref;
  final ChefRepository chefRepository;

  Future<void> getChefs({bool silence = false}) async {
    if (!silence) state = state.copyWith(chefs: StateAsync.loading());
    final res = await chefRepository.getChefs();
    if (!mounted) return;
    res.fold(
      (l) => state = state.copyWith(chefs: StateAsync.error(l)),
      (r) => state = state.copyWith(chefs: StateAsync.success(r)),
    );
  }

  Future<void> createChef({required ChefDto chef}) async {
    ref
        .read(dialogsProvider)
        .showLoadingDialog(ref.read(routerProvider).context, 'Creando chef...');
    final res = await chefRepository.addChef(chef);
    getChefs(silence: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (res != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, res.message);
    }
  }

  Future<void> updateChef({required Chef chef}) async {
    ref
        .read(dialogsProvider)
        .showLoadingDialog(ref.read(routerProvider).context, 'Actualizando chef...');
    final res = await chefRepository.updateChef(chef);
    getChefs(silence: true);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    if (res != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, res.message);
    }
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, 'Chef actualizado');
  }
}

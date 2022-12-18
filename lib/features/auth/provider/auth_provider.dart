// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/auth/provider/auth_state.dart';
import 'package:oyt_front_auth/models/user_model.dart';
import 'package:oyt_front_auth/repositories/auth_repositories.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider.fromRead(ref);
});

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({
    required this.authRepository,
    required this.ref,
    required this.socketIOHandler,
  }) : super(AuthState(authModel: StateAsync.initial()));

  factory AuthProvider.fromRead(Ref ref) {
    final authRepository = ref.read(authRepositoryProvider);
    final socketIo = ref.read(socketProvider);
    return AuthProvider(
      ref: ref,
      authRepository: authRepository,
      socketIOHandler: socketIo,
    );
  }

  final Ref ref;
  final AuthRepository authRepository;
  final SocketIOHandler socketIOHandler;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.login(email, password);
    res.fold(
      (l) {
        state = state.copyWith(authModel: StateAsync.error(l));
        ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(authModel: StateAsync.success(r));
        startListeningSocket();
        ref.read(routerProvider).router.pop();
      },
    );
  }

  Future<void> register(User user, BuildContext context) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.register(user);
    if (res != null) {
      state = state.copyWith(authModel: StateAsync.error(res));
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': res.message});
      return;
    }
    await login(email: user.email, password: user.password ?? '');
    ref.read(routerProvider).router.pop();
  }

  Future<void> logout({String? logoutMessage}) async {
    if (state.authModel.data == null) {
      ref
          .read(routerProvider)
          .router
          .push(ErrorScreen.route, extra: {'error': 'No tienes una sesion activa'});
      return;
    }

    final res = await authRepository.logout();
    if (res != null) {
      state = state.copyWith(authModel: StateAsync.error(res));
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': res.message});
      return;
    }
    stopListeningSocket();
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      logoutMessage ?? 'Se ha cerrado sesion exitosamente.',
    );
    state = AuthState(authModel: StateAsync.initial());
  }

  Future<void> restorePassword(String email) async {
    final res = await authRepository.restorePassword(email);
    if (res != null) return;
  }

  Future<void> getUserByToken() async {
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.getUserByToken();
    res.fold(
      (l) => state = state.copyWith(authModel: StateAsync.error(l)),
      (r) {
        if (r == null) {
          state = state.copyWith(authModel: StateAsync.initial());
          return;
        }
        startListeningSocket();
        state = state.copyWith(authModel: StateAsync.success(r));
      },
    );
  }

  void stopListeningSocket() {
    socketIOHandler.disconnect();
  }

  Future<void> startListeningSocket() async {
    await socketIOHandler.connect();
    //TODO: ADD SOCKET LISTENERS
    // final socketModel = ConnectSocket(
    //   tableId: ref.read(tableProvider).tableCode ?? '',
    //   token: state.authModel.data?.bearerToken ?? '',
    // );
    // ref.read(tableProvider.notifier).listenTableUsers();
    // ref.read(tableProvider.notifier).listenListOfOrders();
    // ref.read(ordersProvider.notifier).listenOnPay();
    //socketIOHandler.emitMap(SocketConstants.joinSocket, socketModel.toMap());
  }
}

// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/core/router/router.dart';
import 'package:oyt_admin/features/auth/provider/auth_state.dart';
import 'package:oyt_admin/features/auth/repositories/auth_repositories.dart';
import 'package:oyt_admin/features/home/ui/index_home_screen.dart';
import 'package:oyt_admin/features/on_boarding/ui/on_boarding.dart';
import 'package:oyt_front_auth/models/login_model.dart';
import 'package:oyt_front_auth/models/user_model.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/push_notifications/push_notif_provider.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider.fromRead(ref);
});

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({
    required this.authRepository,
    required this.ref,
    required this.socketIOHandler,
  }) : super(AuthState.initial());

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
  final AdminAuthRepository authRepository;
  final SocketIOHandler socketIOHandler;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final fcmToken = await ref.read(pushNotificationsProvider).getToken();
    final loginModel = LoginModel(email: email, password: password, deviceToken: fcmToken);
    final res = await authRepository.login(loginModel);
    res.fold(
      (l) {
        state = state.copyWith(authModel: StateAsync.error(l));
        ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) async {
        checkIfIsAdmin();
        state = state.copyWith(authModel: StateAsync.success(r));
        startListeningSocket();
      },
    );
  }

  Future<void> checkIfIsAdmin() async {
    ref.read(dialogsProvider).showLoadingDialog(ref.read(routerProvider).context, null);
    state = state.copyWith(checkAdminResponse: StateAsync.loading());
    final res = await authRepository.checkIfIsAdmin();
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    res.fold(
      (l) => ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message}),
      (r) async {
        state = state.copyWith(checkAdminResponse: StateAsync.success(r));
        if (r.restaurantsId.isEmpty) {
          //TODO: GO TO CREATE A RESTAURANT
        } else if (r.restaurantsId.length > 1) {
          //TODO: GO TO CHOOSE A RESTAURANT
        } else {
          state = state.copyWith(selectedRestaurantId: StateAsync.success(r.restaurantsId.first));
          await authRepository.chooseRestaurantId(r.restaurantsId.first);
          ref.read(routerProvider).router.pushReplacement(IndexHomeScreen.route);
        }
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

  Future<void> logout() async {
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
    Navigator.of(ref.read(routerProvider).context).popUntil((route) => route.isFirst);
    ref.read(routerProvider).router.pushReplacement(OnBoarding.route);
    state = AuthState.initial();
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
      (r) async {
        if (r == null) {
          state = state.copyWith(authModel: StateAsync.initial());
          return;
        }
        checkIfIsAdmin();
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
    //TODO: add socket listeners
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_admin/features/auth/ui/login_screen.dart';
import 'package:oyt_admin/features/auth/ui/register_screen.dart';
import 'package:oyt_admin/features/home/ui/index_home_screen.dart';
import 'package:oyt_admin/features/on_boarding/ui/on_boarding.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  static String atributeErrorMessage(String atribute) {
    return 'Es necesario el parametro $atribute';
  }

  final goRouter = GoRouter(
    initialLocation: OnBoarding.route,
    errorBuilder: (context, state) {
      if (state.error == null) {
        return const ErrorScreen();
      }
      return ErrorScreen(error: state.error.toString());
    },
    routes: routes,
  );

  static List<GoRoute> get routes => [
        GoRoute(path: OnBoarding.route, builder: (context, state) => const OnBoarding()),
        GoRoute(path: RegisterScreen.route, builder: (context, state) => const RegisterScreen()),
        GoRoute(
          path: ErrorScreen.route,
          builder: (context, state) {
            final error = (state.extra as Map<String, dynamic>)['error'];
            if (error == null) {
              return const ErrorScreen();
            }
            return ErrorScreen(error: error);
          },
        ),
        GoRoute(
          path: LoginScreen.route,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: IndexHomeScreen.route,
          builder: (context, state) => const IndexHomeScreen(),
        ),
      ];

  BuildContext get context =>
      goRouter.routeInformationParser.configuration.navigatorKey.currentState!.context;

  GoRouter get router => goRouter;
}

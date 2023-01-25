import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/auth/provider/auth_provider.dart';
import 'package:oyt_admin/features/auth/ui/login_screen.dart';
import 'package:oyt_admin/features/auth/ui/register_screen.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:oyt_front_widgets/widgets/cards/on_boarding_animation_title.dart';
import 'package:oyt_front_widgets/widgets/divider.dart';

class OnBoarding extends ConsumerStatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);
  static const route = '/';

  @override
  ConsumerState<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends ConsumerState<OnBoarding> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).getUserByToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: authState.authModel.on(
        onLoading: () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(LottieAssets.preparingFood, width: 200, height: 200),
            const SizedBox(width: double.infinity),
            const Text('Cargando...', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        onError: (e) => const _OnBoardingBody(),
        onInitial: () => const _OnBoardingBody(),
        onData: (data) => const _OnBoardingBody(),
      ),
    );
  }
}

class _OnBoardingBody extends StatelessWidget {
  const _OnBoardingBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const OnboardingAnimationTitle(),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Bienvenido a la aplicación de administrador.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => handleOnLogin(context),
            child: const Text('Iniciar sesión'),
          ),
          TextButton(
            onPressed: () => handleOnLogin(context),
            child: const Text('Registrarte'),
          ),
          const CustomDivider(),
        ],
      ),
    );
  }

  void handleOnLogin(BuildContext context) => GoRouter.of(context).push(LoginScreen.route);
  void handleOnRegister(BuildContext context) => GoRouter.of(context).push(RegisterScreen.route);
}

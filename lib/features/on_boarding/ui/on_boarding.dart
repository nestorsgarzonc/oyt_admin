import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_widgets/widgets/cards/on_boarding_animation_title.dart';
import 'package:oyt_front_widgets/widgets/divider.dart';

class OnBoarding extends ConsumerWidget {
  const OnBoarding({Key? key}) : super(key: key);
  static const route = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingAnimationTitle(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Bienvenido a la aplicacion de administrador, para continuar inicia sesión o crea una cuenta',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text('Crear cuenta'),
            ),
            const CustomDivider(),
          ],
        ),
      ),
    );
  }
}

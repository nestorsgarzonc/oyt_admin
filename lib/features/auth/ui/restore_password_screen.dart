import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/auth/provider/auth_provider.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/widgets/backgrounds/animated_background.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class RestorePasswordScreen extends ConsumerStatefulWidget {
  const RestorePasswordScreen({super.key});

  static const route = '/restore-password';

  @override
  ConsumerState<RestorePasswordScreen> createState() => _RestorePasswordScreen();
}

class _RestorePasswordScreen extends ConsumerState<RestorePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Ingresa tu correo',
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: 'Correo',
              controller: _emailController,
              validator: TextFormValidator.emailValidator,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: handleOnResetPassword,
              child: const Text('Restaurar contraseña'),
            )
          ],
        ),
      ),
    );
  }

  void handleOnResetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref.read(authProvider.notifier).restorePassword(_emailController.text);
  }
}

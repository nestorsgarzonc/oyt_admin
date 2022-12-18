import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_admin/features/auth/provider/auth_provider.dart';
import 'package:oyt_front_auth/models/user_model.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/widgets/backgrounds/animated_background.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static const route = '/register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return AnimatedBackground(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: GoRouter.of(context).pop,
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
          const Text(
            'Regístrate',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Nombres',
                  validator: TextFormValidator.nameValidator,
                  controller: _firstNameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Apellidos',
                  validator: TextFormValidator.nameValidator,
                  controller: _lastNameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Correo',
                  validator: TextFormValidator.emailValidator,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Contraseña',
                  obscureText: true,
                  maxLines: 1,
                  controller: _passwordController,
                  validator: TextFormValidator.passwordValidator,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Confirma la contraseña',
                  obscureText: true,
                  maxLines: 1,
                  controller: _confirmPasswordController,
                  validator: TextFormValidator.passwordValidator,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Celular',
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: _phoneNumberController,
                  validator: TextFormValidator.cellphonValidator,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          authState.authModel.on(
            onData: (_) => RegisterButton(onPressed: handleOnRegister),
            onError: (_) => RegisterButton(onPressed: handleOnRegister),
            onLoading: () => const LoadingWidget(),
            onInitial: () => RegisterButton(onPressed: handleOnRegister),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void handleOnRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ref.read(authProvider.notifier).register(
          User(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            email: _emailController.text,
            phone: int.parse(_phoneNumberController.text),
            rol: null,
          ),
          context,
        );
  }
}

class RegisterButton extends ConsumerWidget {
  const RegisterButton({required this.onPressed, Key? key}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomElevatedButton(
      onPressed: onPressed,
      child: const Text('Registrarse'),
    );
  }
}

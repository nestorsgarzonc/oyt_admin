import 'package:flutter/material.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class AddCashierDialog extends StatefulWidget {
  const AddCashierDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AddCashierDialog(),
    );
  }

  @override
  State<AddCashierDialog> createState() => _AddCashierDialog();
}

class _AddCashierDialog extends State<AddCashierDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Agregar cajero'),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
        TextButton(onPressed: _onConfirm, child: const Text('Agregar')),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogWidth(),
            const SectionTitle(
              title: 'Correo del cajero',
              subtitle:
                  'Ingresa el correo del cajero que deseas agregar y habilitar su acceso en la aplicacion de cajero.',
            ),
            CustomTextField(
              controller: _emailController,
              validator: TextFormValidator.emailValidator,
              label: 'Correo del cajero',
              hintText: 'Ej: jose.cajero@oyt.com.co',
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop();
  }
}

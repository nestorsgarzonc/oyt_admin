import 'package:flutter/material.dart';
import 'package:oyt_admin/features/chef/models/chef_dto.dart';
import 'package:oyt_admin/features/chef/provider/chef_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class AddChefDialog extends ConsumerStatefulWidget {
  const AddChefDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AddChefDialog(),
    );
  }

  @override
  ConsumerState<AddChefDialog> createState() => _AddCashierDialog();
}

class _AddCashierDialog extends ConsumerState<AddChefDialog> {
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
      title: const DialogHeader(title: 'Agregar chef'),
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
              title: 'Correo del chef',
              subtitle:
                  'Ingresa el correo del chef que deseas agregar y habilitar su acceso en la aplicacion de chef.',
            ),
            CustomTextField(
              controller: _emailController,
              validator: TextFormValidator.emailValidator,
              label: 'Correo del chef',
              hintText: 'Ej: jose.chef@oyt.com.co',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(chefProvider.notifier)
        .createChef(chef: ChefDto(email: _emailController.text));
    if (mounted) Navigator.of(context).pop();
  }
}

import 'package:flutter/material.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class AddTableDialog extends StatefulWidget {
  const AddTableDialog({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
    String subtitle = 'Esta acción no se puede deshacer',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddTableDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<AddTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<AddTableDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      title: const DialogHeader(title: 'Agregar mesa'),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
        TextButton(onPressed: _onConfirm, child: const Text('Agregar')),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DialogWidth(),
          const SectionTitle(title: 'Nombre de la mesa'),
          Form(
            key: _formKey,
            child: CustomTextField(
              controller: _nameController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Nombre de la mesa',
              hintText: 'Ej: Mesa 1',
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm();
      Navigator.of(context).pop();
    }
  }
}

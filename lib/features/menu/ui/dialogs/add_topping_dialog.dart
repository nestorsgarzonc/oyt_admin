import 'package:flutter/material.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_topping_option_dialog.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_menu/enum/topping_options_type.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class AddToppingDialog extends StatefulWidget {
  const AddToppingDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AddToppingDialog(),
    );
  }

  @override
  State<AddToppingDialog> createState() => _AddToppingDialog();
}

class _AddToppingDialog extends State<AddToppingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minOptionsController = TextEditingController(); //?: Number;
  final _maxOptionsController = TextEditingController(); //?: Number;
  ToppingOptionsType _typeEnum = ToppingOptionsType.single;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Agregar topping'),
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
            const SectionTitle(title: 'Nombre del topping'),
            CustomTextField(
              controller: _nameController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Nombre del topping',
              hintText: 'Ej: Queso',
            ),
            const SectionTitle(title: 'Tipo de topping'),
            ...ToppingOptionsType.values.map(
              (e) => Card(
                child: RadioListTile<ToppingOptionsType>(
                  title: Text(e.label),
                  value: e,
                  groupValue: _typeEnum,
                  onChanged: (val) => val == null ? null : setState(() => _typeEnum = val),
                ),
              ),
            ),
            const SectionTitle(title: 'Minimo de opciones'),
            CustomTextField(
              controller: _minOptionsController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Minimo de opciones',
              hintText: 'Ej: 0',
            ),
            const SectionTitle(title: 'Maximo de opciones'),
            CustomTextField(
              controller: _maxOptionsController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Maximo de opciones',
              hintText: 'Ej: 1',
            ),
            const SectionTitle(title: 'Opciones de topping'),
            ...List.generate(
              3,
              (index) => Card(
                child: ListTile(
                  title: Text('Opcion $index'),
                  trailing: const Icon(Icons.arrow_right),
                  subtitle: const Text('Precio: \$ 100'),
                  leading: const FlutterLogo(),
                  onTap: () {},
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: _onAddOptions,
                title: const Text('Agregar opciones'),
                trailing: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddOptions() => AddToppingOptionDialog.show(context: context);

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop();
  }
}

import 'package:flutter/material.dart';
import 'package:oyt_front_core/enums/payments_enum.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/dropdown/custom_dropdown_field.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/text_field/date_text_field.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class FilterHistoricalOrdersDialog extends StatefulWidget {
  const FilterHistoricalOrdersDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const FilterHistoricalOrdersDialog(),
    );
  }

  @override
  State<FilterHistoricalOrdersDialog> createState() => _FilterHistoricalOrdersDialog();
}

class _FilterHistoricalOrdersDialog extends State<FilterHistoricalOrdersDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  DateTime? _initialDate;
  DateTime? _finalDate;
  PaymentMethod? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Filtra las ordenes'),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
        TextButton(onPressed: _onConfirm, child: const Text('Filtrar')),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogWidth(),
            const SectionTitle(title: 'Fecha de inicio'),
            DateTextField(
              label: 'Fecha de inicio',
              onTap: (time) => _initialDate = time,
            ),
            const SectionTitle(title: 'Fecha fin'),
            DateTextField(
              label: 'Fecha fin',
              onTap: (time) => _finalDate = time,
            ),
            const SectionTitle(title: 'Valor de la orden'),
            CustomTextField(
              controller: _valueController,
              validator: TextFormValidator.emailValidator,
              label: 'Valor de la orden',
              hintText: 'Ej: 10.000',
            ),
            const SectionTitle(title: 'Método de pago'),
            CustomDropdownField<PaymentMethod>(
              items: PaymentMethod.values,
              value: _selectedPaymentMethod,
              itemAsString: (item) => item.title,
              onChanged: (value) => setState(() => _selectedPaymentMethod = value),
              labelText: 'Metodo de pago',
              hintText: 'Ej: ${PaymentMethod.values.first.title}}',
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

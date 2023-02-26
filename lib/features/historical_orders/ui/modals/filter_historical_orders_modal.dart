import 'package:flutter/material.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';
import 'package:oyt_admin/features/historical_orders/provider/historical_orders_provider.dart';
import 'package:oyt_front_core/enums/payments_enum.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/dropdown/custom_dropdown_field.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/text_field/date_text_field.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class FilterHistoricalOrdersDialog extends ConsumerStatefulWidget {
  const FilterHistoricalOrdersDialog({super.key, HistoricalOrdersFilter? historicalOrdersFilter});

  static Future<void> show({required BuildContext context, HistoricalOrdersFilter? historicalOrdersFilter}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => FilterHistoricalOrdersDialog(historicalOrdersFilter: historicalOrdersFilter,),
    );
  }

  @override
  ConsumerState<FilterHistoricalOrdersDialog> createState() => _FilterHistoricalOrdersDialog();
}

class _FilterHistoricalOrdersDialog extends ConsumerState<FilterHistoricalOrdersDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  num value = 0;
  PaymentMethod? _selectedPaymentMethod;
  HistoricalOrdersFilter? historicalOrdersFilter = HistoricalOrdersFilter();

  @override
  Widget build(BuildContext context) {
    final historicalOrdersState = ref.watch(historicalOrdersProvider);
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Filtra las ordenes'),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
        TextButton(onPressed: () => _onConfirm(historicalOrdersState.historicalOrdersFilter), child: const Text('Filtrar')),
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
              onTap: (time) => historicalOrdersFilter?.dateStart = time,
            ),
            const SectionTitle(title: 'Fecha fin'),
            DateTextField(
              label: 'Fecha fin',
              onTap: (time) => historicalOrdersFilter?.dateEnd = time,
            ),
            const SectionTitle(title: 'Valor de la orden'),
            CustomTextField(
              controller: _valueController,
              validator: TextFormValidator.orderPriceValidator,
              label: 'Valor de la orden',
              onTap: () {
                if(_valueController.text.isNotEmpty) {
                  historicalOrdersFilter?.orderPrice = _valueController.text as num?;
                }
              },
              hintText: 'Ej: 10.000',
            ),
            const SectionTitle(title: 'Método de pago'),
            CustomDropdownField<PaymentMethod>(
              items: PaymentMethod.values,
              value: _selectedPaymentMethod,
              itemAsString: (item) => item.title,
              onChanged: (value) => setState(() => historicalOrdersFilter
                ?.paymentMethod = value?.paymentValue,),
              labelText: 'Metodo de pago',
              hintText: 'Ej: ${PaymentMethod.values.first.title}}',
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm(HistoricalOrdersFilter? ordersfilter) {
    if (!_formKey.currentState!.validate()) return;
    ref.read(historicalOrdersProvider.notifier).resetState();
    ref.read(historicalOrdersProvider.notifier).getMoreHistoricalOrders(pageIndex: 1, historicalOrdersFilter: historicalOrdersFilter);
    Navigator.of(context).pop();
  }
}

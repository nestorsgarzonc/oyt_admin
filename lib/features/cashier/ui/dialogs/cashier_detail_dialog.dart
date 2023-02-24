import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/cashier/models/cashier_model.dart';
import 'package:oyt_admin/features/cashier/provider/cashier_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class CashierDetailDialog extends ConsumerStatefulWidget {
  const CashierDetailDialog({super.key, required this.cashier});

  final Cashier cashier;

  static Future<void> show({required BuildContext context, required Cashier cashier}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CashierDetailDialog(cashier: cashier),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CashierDetailDialogState();
}

class _CashierDetailDialogState extends ConsumerState<CashierDetailDialog> {
  bool isAvailable = false;

  @override
  void initState() {
    isAvailable = widget.cashier.isAvailable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Detalle de cajero'),
      actions: isAvailable != widget.cashier.isAvailable
          ? [
              TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
              TextButton(onPressed: _onEdit, child: const Text('Editar')),
            ]
          : [
              TextButton(onPressed: Navigator.of(context).pop, child: const Text('Salir')),
            ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const DialogWidth(),
          const SectionTitle(title: 'Nombre del cajero'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(
                text: '${widget.cashier.firstName} ${widget.cashier.lastName}'),
            label: 'Nombre del cajero',
          ),
          const SectionTitle(title: 'Correo electrónico'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(text: widget.cashier.email),
            label: 'Correo electrónico',
          ),
          const SectionTitle(title: 'Fecha de creación'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(text: widget.cashier.createdAt.toString()),
            label: 'Fecha de creación',
          ),
          const SectionTitle(title: 'Esta activo'),
          Card(
            child: CheckboxListTile(
              title: const Text('Esta activo'),
              value: isAvailable,
              onChanged: (val) {
                if (mounted && val != null) setState(() => isAvailable = val);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onEdit() async {
    await ref.read(cashierProvider.notifier).updateCashier(
          cashier: widget.cashier.copyWith(isAvailable: isAvailable),
        );
    if (mounted) Navigator.of(context).pop();
  }
}

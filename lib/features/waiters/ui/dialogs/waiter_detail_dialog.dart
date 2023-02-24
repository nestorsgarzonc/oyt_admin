import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/waiters/models/waiter_model.dart';
import 'package:oyt_admin/features/waiters/provider/waiter_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class WaiterDetailDialog extends ConsumerStatefulWidget {
  const WaiterDetailDialog({super.key, required this.waiter});

  final Waiter waiter;

  static Future<void> show({required BuildContext context, required Waiter waiter}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WaiterDetailDialog(waiter: waiter),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WaiterDetailDialogState();
}

class _WaiterDetailDialogState extends ConsumerState<WaiterDetailDialog> {
  bool isAvailable = false;

  @override
  void initState() {
    isAvailable = widget.waiter.isAvailable;
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
      title: const DialogHeader(title: 'Detalle de mesero'),
      actions: isAvailable != widget.waiter.isAvailable
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
          const SectionTitle(title: 'Nombre del mesero'),
          CustomTextField(
            enabled: false,
            controller:
                TextEditingController(text: '${widget.waiter.firstName} ${widget.waiter.lastName}'),
            label: 'Nombre del mesero',
          ),
          const SectionTitle(title: 'Correo electrónico'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(text: widget.waiter.email),
            label: 'Correo electrónico',
          ),
          const SectionTitle(title: 'Fecha de creación'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(text: widget.waiter.createdAt.toString()),
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
    await ref.read(waiterProvider.notifier).updateWaiter(
          waiter: widget.waiter.copyWith(isAvailable: isAvailable),
        );
    if (mounted) Navigator.of(context).pop();
  }
}

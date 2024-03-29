import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';
import 'package:oyt_admin/features/chef/provider/chef_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class ChefDetailDialog extends ConsumerStatefulWidget {
  const ChefDetailDialog({super.key, required this.chef});

  final Chef chef;

  static Future<void> show({required BuildContext context, required Chef chef}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ChefDetailDialog(chef: chef),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChefDetailDialogState();
}

class _ChefDetailDialogState extends ConsumerState<ChefDetailDialog> {
  bool isAvailable = false;

  @override
  void initState() {
    isAvailable = widget.chef.isAvailable;
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
      title: const DialogHeader(title: 'Detalle de chef'),
      actions: isAvailable != widget.chef.isAvailable
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
          const SectionTitle(title: 'Nombre del chef'),
          CustomTextField(
            enabled: false,
            controller:
                TextEditingController(text: '${widget.chef.firstName} ${widget.chef.lastName}'),
            label: 'Nombre del chef',
          ),
          const SectionTitle(title: 'Correo electrónico'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(text: widget.chef.email),
            label: 'Correo electrónico',
          ),
          const SectionTitle(title: 'Fecha de creación'),
          CustomTextField(
            enabled: false,
            controller: TextEditingController(text: widget.chef.createdAt.toString()),
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
    await ref.read(chefProvider.notifier).updateChef(
          chef: widget.chef.copyWith(isAvailable: isAvailable),
        );
    if (mounted) Navigator.of(context).pop();
  }
}

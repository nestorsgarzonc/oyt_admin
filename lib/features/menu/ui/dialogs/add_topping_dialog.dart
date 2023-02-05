import 'package:flutter/material.dart';
import 'package:oyt_admin/features/menu/provider/menu_provider.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_topping_option_dialog.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:oyt_front_core/utils/formatters.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_menu/enum/topping_options_type.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToppingDialog extends ConsumerStatefulWidget {
  const AddToppingDialog({super.key, this.toppingItem, required this.menuItem});

  static Future<void> show({
    required BuildContext context,
    Topping? toppingItem,
    required MenuItem menuItem,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AddToppingDialog(toppingItem: toppingItem, menuItem: menuItem),
    );
  }

  final Topping? toppingItem;
  final MenuItem menuItem;

  @override
  ConsumerState<AddToppingDialog> createState() => _AddToppingDialog();
}

class _AddToppingDialog extends ConsumerState<AddToppingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minOptionsController = TextEditingController(); //?: Number;
  final _maxOptionsController = TextEditingController(); //?: Number;
  ToppingOptionsType _typeEnum = ToppingOptionsType.single;

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    _nameController.text = widget.toppingItem?.name ?? '';
    _maxOptionsController.text = widget.toppingItem?.maxOptions.toString() ?? '1';
    _minOptionsController.text = widget.toppingItem?.minOptions.toString() ?? '0';
    _typeEnum = widget.toppingItem?.type ?? ToppingOptionsType.single;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: DialogHeader(title: '${widget.toppingItem == null ? 'Agregar' : 'Editar'} topping'),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
        TextButton(
          onPressed: _onConfirm,
          child: Text(widget.toppingItem == null ? 'Agregar' : 'Editar'),
        ),
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
                  onChanged: (val) {
                    if (val == null) return;
                    if (val == ToppingOptionsType.single) {
                      _minOptionsController.text = '0';
                      _maxOptionsController.text = '1';
                    }
                    setState(() => _typeEnum = val);
                  },
                ),
              ),
            ),
            const SectionTitle(title: 'Minimo de opciones'),
            CustomTextField(
              enabled: ToppingOptionsType.single != _typeEnum,
              controller: _minOptionsController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Minimo de opciones',
              hintText: 'Ej: 0',
            ),
            const SectionTitle(title: 'Maximo de opciones'),
            CustomTextField(
              enabled: ToppingOptionsType.single != _typeEnum,
              controller: _maxOptionsController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Maximo de opciones',
              hintText: 'Ej: 1',
            ),
            if (widget.toppingItem != null) ...[
              const SectionTitle(title: 'Opciones de topping'),
              ...widget.toppingItem!.options.map(
                (e) => Card(
                  child: ListTile(
                    title: Text(e.name),
                    trailing: const Icon(Icons.arrow_right),
                    subtitle: Text('Precio: \$ ${CurrencyFormatter.format(e.price)}'),
                    leading: ImageApi(e.imgUrl, width: 50, height: 50, fit: BoxFit.cover),
                    onTap: () => _onAddOptions(toppingOption: e, topping: widget.toppingItem!),
                  ),
                ),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  onTap: () => _onAddOptions(topping: widget.toppingItem!),
                  title: const Text('Agregar opciones'),
                  trailing: const Icon(Icons.add),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onAddOptions({Option? toppingOption, required Topping topping}) =>
      AddToppingOptionDialog.show(
        context: context,
        toppingOption: toppingOption,
        topping: topping,
      );

  void _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.toppingItem != null) {
      await ref.read(menuProvider.notifier).updateTopping(
            widget.toppingItem!.copyWith(
              name: _nameController.text,
              type: _typeEnum,
              minOptions: int.parse(_minOptionsController.text),
              maxOptions: int.parse(_maxOptionsController.text),
            ),
          );
    } else {
      await ref.read(menuProvider.notifier).addTopping(
            widget.menuItem,
            Topping(
              name: _nameController.text,
              type: _typeEnum,
              minOptions: int.parse(_minOptionsController.text),
              maxOptions: int.parse(_maxOptionsController.text),
              id: '',
              options: const [],
            ),
          );
    }
    if (mounted) Navigator.of(context).pop();
  }
}

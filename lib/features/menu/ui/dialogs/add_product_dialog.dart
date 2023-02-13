import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oyt_admin/features/menu/provider/menu_provider.dart';
import 'package:oyt_front_core/extensions/uint8list_extension.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/custom_image_picker.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_widgets/cards/upload_image_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({required this.category, super.key, this.menuItem});

  static Future<void> show({
    required BuildContext context,
    MenuItem? menuItem,
    required Menu category,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AddProductDialog(menuItem: menuItem, category: category),
    );
  }

  final MenuItem? menuItem;
  final Menu category;

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialog();
}

class _AddProductDialog extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(); //: Number;
  Uint8List? _imgBytes;
  bool _isAvailable = true;
  bool _isLoadinglogo = false;

  @override
  void initState() {
    if (widget.menuItem != null) setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    final menuItem = widget.menuItem!;
    _nameController.text = menuItem.name;
    _descriptionController.text = menuItem.description;
    _priceController.text = menuItem.price.toString();
    _isAvailable = menuItem.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Agregar producto'),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancelar')),
        TextButton(
          onPressed: _onConfirm,
          child: Text(widget.menuItem == null ? 'Agregar' : 'Editar'),
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogWidth(),
            const SectionTitle(title: 'Nombre del producto'),
            CustomTextField(
              controller: _nameController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Nombre del producto',
              hintText: 'Ej: Hamburguesas',
            ),
            const SectionTitle(title: 'Descripción del producto'),
            CustomTextField(
              controller: _descriptionController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              maxLines: 3,
              label: 'Descripción del producto',
            ),
            const SectionTitle(title: 'Precio del producto'),
            CustomTextField(
              controller: _priceController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Precio del producto',
              hintText: 'Ej: 1.000',
            ),
            // const SectionTitle(title: 'Impuestos del producto'),
            // CustomTextField(
            //   controller: _taxesController,
            //   validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
            //   label: 'Impuestos del producto',
            //   hintText: 'Ej: 100',
            // ),
            // const SectionTitle(title: 'Descuentos del producto'),
            // CustomTextField(
            //   controller: _discountController,
            //   validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
            //   label: 'Descuentos del producto',
            //   hintText: 'Ej: 100',
            // ),
            const SectionTitle(title: 'Imagen del producto'),
            UploadImageCard(
              label: 'imagen',
              onReplace: () => ConfirmActionDialog.show(
                context: context,
                title: '¿Estas seguro de remplazar la imagen?',
                onConfirm: _onReplaceLogo,
              ),
              onUpload: _onUploadLogo,
              url: widget.menuItem?.imgUrl,
              isLoading: _isLoadinglogo,
              imgBytes: _imgBytes,
              recomendations: const [
                'Tamaño recomendado: 80x80',
                'Formato: PNG',
                'Fondo transparente'
              ],
            ),
            const SectionTitle(title: '¿Esta producto está disponible?'),
            Card(
              child: CheckboxListTile(
                title: const Text('Disponible'),
                value: _isAvailable,
                onChanged: (val) => val == null ? null : setState(() => _isAvailable = val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUploadLogo() async {
    try {
      setState(() => _isLoadinglogo = true);
      final logo = await CustomImagePicker.pickImage();
      _imgBytes = await logo?.readAsBytes();
    } catch (e) {
      CustomSnackbar.showSnackBar(context, 'Error al subir la imagen');
    } finally {
      setState(() => _isLoadinglogo = false);
    }
  }

  Future<void> _onReplaceLogo() async {
    _onUploadLogo().then((value) {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  void _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imgBytes == null && widget.menuItem == null) {
      CustomSnackbar.showSnackBar(context, 'Debes subir una imagen');
      return;
    }
    if (widget.menuItem != null) {
      await ref.read(menuProvider.notifier).updateMenuItem(
            widget.menuItem!.copyWithForUpdate(
              description: _descriptionController.text,
              name: _nameController.text,
              price: int.tryParse(_priceController.text),
              isAvailable: _isAvailable,
              img: _imgBytes?.toBase64,
            ),
            widget.menuItem!.isAvailable != _isAvailable,
          );
    } else {
      await ref.read(menuProvider.notifier).addMenuItem(
            widget.category,
            MenuItem(
              description: _descriptionController.text,
              name: _nameController.text,
              price: int.tryParse(_priceController.text) ?? 0,
              isAvailable: _isAvailable,
              imgUrl: _imgBytes?.toBase64 ?? '',
              id: '',
            ),
          );
    }
    if (mounted) Navigator.of(context).pop();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/custom_image_picker.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_widgets/cards/upload_image_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AddProductDialog(),
    );
  }

  @override
  State<AddProductDialog> createState() => _AddProductDialog();
}

class _AddProductDialog extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(); //: Number;
  final _taxesController = TextEditingController(); //?: Number;
  final _discountController = TextEditingController(); //?: Number;
  Uint8List? _imgBytes;
  bool _isAvaliable = true;
  bool _isLoadinglogo = false;

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
        TextButton(onPressed: _onConfirm, child: const Text('Agregar')),
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
            const SectionTitle(title: 'Impuestos del producto'),
            CustomTextField(
              controller: _taxesController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Impuestos del producto',
              hintText: 'Ej: 100',
            ),
            const SectionTitle(title: 'Descuentos del producto'),
            CustomTextField(
              controller: _discountController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Descuentos del producto',
              hintText: 'Ej: 100',
            ),
            const SectionTitle(title: 'Imagen del producto'),
            UploadImageCard(
              label: 'imagen',
              onRemove: () => ConfirmActionDialog.show(
                context: context,
                title: '¿Estas seguro de eliminar la imagen?',
                onConfirm: _onRemoveLogo,
              ),
              onReplace: () => ConfirmActionDialog.show(
                context: context,
                title: '¿Estas seguro de remplazar la imagen?',
                onConfirm: _onReplaceLogo,
              ),
              onUpload: _onUploadLogo,
              url: null,
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
                value: _isAvaliable,
                onChanged: (val) => val == null ? null : setState(() => _isAvaliable = val),
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

  Future<void> _onRemoveLogo() async {
    if (_imgBytes != null) {
      _imgBytes = null;
      setState(() {});
    } else {
      //TODO: ADD FOR NETWORK IMG
    }
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate()) return;
    if (_imgBytes == null) {
      CustomSnackbar.showSnackBar(context, 'Debes subir una imagen');
      return;
    }
    Navigator.of(context).pop();
  }
}

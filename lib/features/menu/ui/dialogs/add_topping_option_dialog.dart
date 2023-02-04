import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/custom_image_picker.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:oyt_front_widgets/cards/upload_image_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:oyt_front_widgets/dialogs/widgets/dialog_header.dart';
import 'package:oyt_front_widgets/sizedbox/dialog_width.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToppingOptionDialog extends ConsumerStatefulWidget {
  const AddToppingOptionDialog({super.key, required this.toppingOption});

  static Future<void> show({required BuildContext context, required Option? toppingOption}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AddToppingOptionDialog(toppingOption: toppingOption),
    );
  }

  final Option? toppingOption;

  @override
  ConsumerState<AddToppingOptionDialog> createState() => _AddToppingOptionDialog();
}

class _AddToppingOptionDialog extends ConsumerState<AddToppingOptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController(); //?: Number;
  Uint8List? _imgBytes;
  bool _isLoadinglogo = false;

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    _nameController.text = widget.toppingOption?.name ?? '';
    _priceController.text = widget.toppingOption?.price.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: CustomTheme.dialogPadding.copyWith(bottom: 0),
      contentPadding: CustomTheme.dialogPadding.copyWith(top: 0),
      actionsPadding: CustomTheme.dialogPadding,
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
      title: const DialogHeader(title: 'Agregar opcion de topping'),
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
            const SectionTitle(title: 'Precio del topping'),
            CustomTextField(
              controller: _priceController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Precio del topping',
              hintText: 'Ej: 1000',
            ),
            const SectionTitle(title: 'Imagen del topping'),
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
    Navigator.of(context).pop();
  }
}

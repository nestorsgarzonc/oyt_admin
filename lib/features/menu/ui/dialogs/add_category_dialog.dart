import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oyt_front_core/logger/logger.dart';
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

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
  }

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialog();
}

class _AddCategoryDialog extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
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
      title: const DialogHeader(title: 'Agregar categoría'),
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
            const SectionTitle(title: 'Nombre de la categoría'),
            CustomTextField(
              controller: _nameController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              label: 'Nombre de la categoría',
              hintText: 'Ej: Hamburguesas',
            ),
            const SectionTitle(title: 'Descripción de la categoría'),
            CustomTextField(
              controller: _descriptionController,
              validator: (val) => TextFormValidator.mandatoryFieldValidator(val),
              maxLines: 3,
              label: 'Descripción de la categoría',
            ),
            const SectionTitle(title: 'Imagen de la categoría'),
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
            const SectionTitle(title: '¿Esta categoría está disponible?'),
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
      if (_imgBytes != null) {
        final encoded = await compute(base64Encode, _imgBytes!);
        Logger.log('Encoded64: $encoded');
      }
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

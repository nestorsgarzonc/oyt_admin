import 'dart:convert';
import 'package:oyt_front_core/extensions/uint8list_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oyt_admin/features/menu/provider/menu_provider.dart';
import 'package:oyt_front_core/logger/logger.dart';
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

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({required this.categoryItem, super.key});

  static Future<void> show({required BuildContext context, Menu? categoryItem}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AddCategoryDialog(categoryItem: categoryItem),
    );
  }

  final Menu? categoryItem;

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialog();
}

class _AddCategoryDialog extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? _imgBytes;
  bool _isAvailable = true;
  bool _isLoadinglogo = false;
  Menu? categoryItem;

  @override
  void initState() {
    categoryItem = widget.categoryItem;
    if (widget.categoryItem != null) setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    _nameController.text = categoryItem?.name ?? '';
    _descriptionController.text = categoryItem?.description ?? '';
    _isAvailable = categoryItem?.isAvailable ?? true;
  }

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
        TextButton(
          onPressed: _onConfirm,
          child: Text(widget.categoryItem == null ? 'Agregar' : 'Editar'),
        ),
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
              onReplace: () => ConfirmActionDialog.show(
                context: context,
                title: '¿Estas seguro de remplazar la imagen?',
                onConfirm: _onReplaceLogo,
              ),
              onUpload: _onUploadLogo,
              url: categoryItem?.imgUrl,
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

  void _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imgBytes == null && categoryItem?.imgUrl == null) {
      CustomSnackbar.showSnackBar(context, 'Debes subir una imagen');
      return;
    }
    if (categoryItem != null) {
      await ref.read(menuProvider.notifier).updateCategory(
            categoryItem!.copyWithForUpdate(
              img: _imgBytes?.toBase64,
              name: _nameController.text,
              description: _descriptionController.text,
              isAvailable: _isAvailable,
            ),
            categoryItem!.isAvailable!=_isAvailable,
          );
    } else {
      await ref.read(menuProvider.notifier).addCategory(
            Menu(
              id: '',
              menuItems: const [],
              imgUrl: _imgBytes!.toBase64,
              name: _nameController.text,
              description: _descriptionController.text,
              isAvailable: _isAvailable,
            ),
          );
    }
    if (context.mounted) Navigator.of(context).pop();
  }
}

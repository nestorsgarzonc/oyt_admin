import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_front_core/enums/payments_enum.dart';
import 'package:oyt_front_core/enums/weekdays_enum.dart';
import 'package:oyt_front_core/utils/custom_image_picker.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/cards/upload_image_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';
import 'package:oyt_front_widgets/text_field/time_text_field.dart';

class RestaurantTab extends ConsumerStatefulWidget {
  const RestaurantTab({super.key});

  @override
  ConsumerState<RestaurantTab> createState() => _RestaurantTab();
}

class _RestaurantTab extends ConsumerState<RestaurantTab> {
  final _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  Uint8List? _logo;
  Uint8List? _cover;
  bool _isLoadinglogo = false;
  bool _isLoadingCover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Restaurante',
          subtitle: 'Acá puedes ver información del restaurante, administrarlo y personalizarlo.',
        ),
        const SizedBox(height: 10),
        const Divider(),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              children: [
                const SectionTitle(title: 'Logo'),
                UploadImageCard(
                  label: 'logo',
                  onRemove: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de eliminar el logo?',
                    onConfirm: _onRemoveLogo,
                  ),
                  onReplace: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de remplazar el logo?',
                    onConfirm: _onReplaceLogo,
                  ),
                  onUpload: _onUploadLogo,
                  url: null,
                  isLoading: _isLoadinglogo,
                  imgBytes: _logo,
                  recomendations: const [
                    'Tamaño recomendado: 200x200',
                    'Formato: PNG',
                    'Fondo transparente'
                  ],
                ),
                const SectionTitle(title: 'Portada'),
                UploadImageCard(
                  label: 'portada',
                  fit: BoxFit.cover,
                  onRemove: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de eliminar la portada?',
                    onConfirm: _onRemoveCover,
                  ),
                  onReplace: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de remplazar la portada?',
                    onConfirm: _onReplaceCover,
                  ),
                  onUpload: _onUploadCover,
                  showLarge: true,
                  isLoading: _isLoadingCover,
                  imgBytes: _cover,
                  recomendations: const [
                    'Tamaño recomendado: 1000x500',
                    'Formato: PNG, JPG o JPEG',
                  ],
                  url: null,
                ),
                const SectionTitle(title: 'Nombre del restaurante'),
                CustomTextField(label: 'Nombre del restaurante', controller: _nameController),
                const SectionTitle(title: 'Descripción'),
                CustomTextField(
                  label: 'Descripción del restaurante',
                  controller: _descriptionController,
                  maxLines: 5,
                ),
                const SectionTitle(title: 'Dirección'),
                CustomTextField(
                  label: 'Dirección del restaurante',
                  controller: _addressController,
                  maxLines: 1,
                ),
                const SectionTitle(title: 'Horario'),
                ...Weekdays.values.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${e.name}:',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TimeTextField(
                            label: 'Hora de apertura',
                            onTap: (time) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TimeTextField(
                            label: 'Hora de cierre',
                            onTap: (time) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SectionTitle(title: 'Redes sociales'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Facebook',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Instagram',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Contacto'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Teléfono',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Correo electrónico',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Métodos de pago'),
                ...PaymentMethod.values
                    .map(
                      (e) => Card(
                        child: CheckboxListTile(
                          title: Text(e.title),
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: IconButton(
                            icon: const Icon(Icons.help_outline),
                            onPressed: () {},
                          ),
                          value: true,
                          onChanged: (value) {},
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onUploadLogo() async {
    try {
      setState(() => _isLoadinglogo = true);
      final logo = await CustomImagePicker.pickImage();
      _logo = await logo?.readAsBytes();
      setState(() => _isLoadinglogo = false);
    } catch (e) {
      CustomSnackbar.showSnackBar(context, 'Error al subir la imagen');
      setState(() => _isLoadinglogo = false);
    }
  }

  Future<void> _onUploadCover() async {
    try {
      setState(() => _isLoadingCover = true);
      final cover = await CustomImagePicker.pickImage();
      _cover = await cover?.readAsBytes();
      setState(() => _isLoadingCover = false);
    } catch (e) {
      CustomSnackbar.showSnackBar(context, 'Error al subir la imagen');
      setState(() => _isLoadingCover = false);
    }
  }

  Future<void> _onReplaceLogo() async {
    _onUploadLogo().then((value) {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  Future<void> _onReplaceCover() async {
    _onUploadCover().then((value) {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  Future<void> _onRemoveLogo() async {
    if (_logo != null) {
      _logo = null;
      setState(() {});
    } else {
      //TODO: ADD FOR NETWORK IMG
    }
    Navigator.of(context).pop();
  }

  Future<void> _onRemoveCover() async {
    if (_cover != null) {
      _cover = null;
      setState(() {});
    } else {
      //TODO: ADD FOR NETWORK IMG
    }
    Navigator.of(context).pop();
  }
}

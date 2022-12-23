import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/cards/upload_image_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';

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
                    onConfirm: () {},
                  ),
                  onReplace: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de remplazar el logo?',
                    onConfirm: () {},
                  ),
                  //TODO: ADD ON UPLOAD
                  onUpload: () {},
                  url: null,
                  recomendations: const [
                    'Tamaño recomendado: 200x200',
                    'Formato: PNG',
                    'Fondo transparente'
                  ],
                ),
                const SectionTitle(title: 'Portada'),
                UploadImageCard(
                  label: 'portada',
                  onRemove: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de eliminar la portada?',
                    onConfirm: () {},
                  ),
                  onReplace: () => ConfirmActionDialog.show(
                    context: context,
                    title: '¿Estas seguro de remplazar la portada?',
                    onConfirm: () {},
                  ),
                  onUpload: () {},
                  showLarge: true,
                  recomendations: const [
                    'Tamaño recomendado: 1000x500',
                    'Formato: PNG, JPG o JPEG',
                  ],
                  url: null,
                ),
                const SectionTitle(title: 'Nombre del restaurante'),
                CustomTextField(
                  label: 'Nombre del restaurante',
                  controller: _nameController,
                ),
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Hora de apertura',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Hora de cierre',
                        controller: _nameController,
                      ),
                    ),
                  ],
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
                const SectionTitle(title: 'Ubicación'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Latitud',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Longitud',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Categorías'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Categoría 1',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Categoría 2',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Métodos de pago'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Método 1',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Método 2',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Métodos de envío'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Método 1',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Método 2',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Métodos de retiro'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Método 1',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Método 2',
                        controller: _nameController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

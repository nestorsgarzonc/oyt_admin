import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_restaurant/models/restaurant_creation_model.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_admin/features/restaurant/ui/widgets/download_restaurant_qr.dart';
import 'package:oyt_front_core/enums/payments_enum.dart';
import 'package:oyt_front_core/enums/weekdays_enum.dart';
import 'package:oyt_front_core/utils/custom_image_picker.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/cards/upload_image_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';
import 'package:oyt_front_widgets/text_field/time_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/url/url_builder.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_core/extensions/uint8list_extension.dart';

class RestaurantBody extends ConsumerStatefulWidget {
  const RestaurantBody({required this.onRestaurantChanged, required this.restaurant, super.key});

  final RestaurantModel? restaurant;
  final ValueChanged<RestaurantCreationModel> onRestaurantChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RestaurantTabBodyState();
}

class _RestaurantTabBodyState extends ConsumerState<RestaurantBody> {
  final _scrollController = ScrollController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _paymentMethods = <PaymentMethod>{};
  final _formKey = GlobalKey<FormState>();
  List<Weekday> _weekDays = Weekday.weekdays;
  Uint8List? _logo;
  Uint8List? _cover;
  bool _isLoadinglogo = false;
  bool _isLoadingCover = false;
  RestaurantModel? restaurant;
  Color _primaryColor = Colors.deepOrange;
  Color _secondaryColor = Colors.blue;

  @override
  void initState() {
    restaurant = widget.restaurant;
    if (restaurant == null) {
      super.initState();
      return;
    }
    _nameController.text = restaurant?.name ?? '';
    _descriptionController.text = restaurant?.description ?? '';
    _addressController.text = restaurant?.address ?? '';
    _emailController.text = restaurant?.email ?? '';
    _phoneController.text = restaurant?.phone.toString() ?? '';
    _instagramController.text = restaurant?.instagram ?? '';
    _facebookController.text = restaurant?.facebook ?? '';
    _primaryColor = restaurant?.primaryColor ?? Colors.deepOrange;
    _secondaryColor = restaurant?.secondaryColor ?? Colors.blue;
    _paymentMethods.addAll(restaurant?.paymentMethods ?? []);
    _weekDays = restaurant?.weekDays ?? Weekday.weekdays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Restaurante',
          subtitle: 'Acá puedes ver información del restaurante, administrarlo y personalizarlo.',
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                children: [
                  if (restaurant?.id != null) ...[
                    const SectionTitle(title: 'Codigo QR del restaurante'),
                    DownloadRestaurantQR(
                      restaurantName: restaurant!.name,
                      qrData: UrlBuilder.dinnerWithRestaurantId(restaurant!.id),
                    ),
                  ],
                  const SectionTitle(title: 'Logo'),
                  UploadImageCard(
                    label: 'logo',
                    onReplace: () => ConfirmActionDialog.show(
                      context: context,
                      title: '¿Estas seguro de remplazar el logo?',
                      onConfirm: _onReplaceLogo,
                    ),
                    onUpload: _onUploadLogo,
                    url: restaurant?.logoUrl,
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
                    url: restaurant?.imageUrl,
                  ),
                  const SectionTitle(title: 'Color primario'),
                  ColorPicker(
                    pickerAreaBorderRadius: BorderRadius.circular(12),
                    pickerColor: _primaryColor,
                    onColorChanged: (color) => _primaryColor = color,
                  ),
                  const SectionTitle(title: 'Color secundario'),
                  ColorPicker(
                    pickerAreaBorderRadius: BorderRadius.circular(12),
                    pickerColor: _secondaryColor,
                    onColorChanged: (color) => _secondaryColor = color,
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
                  ..._weekDays.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${e.weekday.spanishName}:',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TimeTextField(
                              label: 'Hora de apertura',
                              onTap: (time) => setState(() => e.openTime = time),
                              initialTime: e.openTime,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: TimeTextField(
                              label: 'Hora de cierre',
                              onTap: (time) => setState(() => e.closeTime = time),
                              initialTime: e.closeTime,
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
                        child: CustomTextField(label: 'Facebook', controller: _facebookController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            CustomTextField(label: 'Instagram', controller: _instagramController),
                      ),
                    ],
                  ),
                  const SectionTitle(title: 'Contacto'),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Teléfono',
                          controller: _phoneController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          label: 'Correo electrónico',
                          controller: _emailController,
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
                              onPressed: () => _onHelpPaymentMethod(e),
                            ),
                            value: _paymentMethods.contains(e),
                            onChanged: (_) => _onSelectPaymentMethod(e),
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 20),
                  FilledButton(onPressed: _onSave, child: const Text('Guardar')),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    //TODO: Continue with the validations
    final restaurantModel = RestaurantCreationModel(
      address: _addressController.text,
      description: _descriptionController.text,
      email: _emailController.text,
      facebook: _facebookController.text,
      imageBase64: _cover?.toBase64,
      instagram: _instagramController.text,
      logoBase64: _logo?.toBase64,
      name: _nameController.text,
      paymentMethods: _paymentMethods.toList(),
      phone: _phoneController.text,
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      weekDays: _weekDays,
    );
    widget.onRestaurantChanged(restaurantModel);
  }

  void _onHelpPaymentMethod(PaymentMethod method) {
    //TODO: Implement
  }

  void _onSelectPaymentMethod(PaymentMethod method) {
    if (_paymentMethods.contains(method)) {
      _paymentMethods.remove(method);
    } else {
      _paymentMethods.add(method);
    }
    setState(() {});
  }

  Future<void> _onUploadLogo() async {
    try {
      setState(() => _isLoadinglogo = true);
      final logo = await CustomImagePicker.pickImage();
      _logo = await logo?.readAsBytes();
    } catch (e) {
      CustomSnackbar.showSnackBar(context, 'Error al subir la imagen');
    } finally {
      setState(() => _isLoadinglogo = false);
    }
  }

  Future<void> _onUploadCover() async {
    try {
      setState(() => _isLoadingCover = true);
      final cover = await CustomImagePicker.pickImage();
      _cover = await cover?.readAsBytes();
    } catch (e) {
      CustomSnackbar.showSnackBar(context, 'Error al subir la imagen');
    } finally {
      setState(() => _isLoadingCover = false);
    }
  }

  Future<void> _onReplaceLogo() async {
    _onUploadLogo().then((value) {
      if (!mounted) return;
      Navigator.of(context).pop();
      if (widget.restaurant == null || _logo == null) return;
      ref.read(restaurantProvider.notifier).updateRestaurantLogo(_logo!);
    });
  }

  Future<void> _onReplaceCover() async {
    _onUploadCover().then((value) {
      if (!mounted) return;
      Navigator.of(context).pop();
      if (widget.restaurant == null || _cover == null) return;
      ref.read(restaurantProvider.notifier).updateRestaurantImage(_cover!);
    });
  }
}

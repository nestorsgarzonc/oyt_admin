import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/widget_to_img.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:share_plus/share_plus.dart';

class TableScreen extends ConsumerStatefulWidget {
  const TableScreen({required this.id, super.key});

  static const route = '/table';

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _qrKey = GlobalKey();
  final _drawerController = ScrollController();
  final _bodyController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 320,
            padding: const EdgeInsets.all(15),
            decoration: CustomTheme.drawerBoxDecoration,
            child: Scrollbar(
              controller: _drawerController,
              child: ListView(
                controller: _drawerController,
                children: [
                  const SafeArea(bottom: false, child: SizedBox.shrink()),
                  Row(
                    children: [
                      const BackButton(),
                      Expanded(
                        child: Text(
                          'Mesa ${widget.id}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  const SectionTitle(title: 'Nombre de la mesa'),
                  CustomTextField(label: 'Nombre de la mesa', controller: _name),
                  const SectionTitle(title: 'Id de la mesa'),
                  CustomTextField(
                    label: 'Id de la mesa',
                    controller: _id,
                    enabled: false,
                  ),
                  const SectionTitle(title: 'Codigo QR de la mesa'),
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      decoration: CustomTheme.drawerBoxDecoration.copyWith(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          QrImage(data: widget.id),
                          const Text(
                            'Takuma',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                          const SizedBox(height: 2),
                          Text('Mesa ${widget.id}'),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _onDownloadQr,
                    icon: const Icon(Icons.download),
                    label: const Text('Descargar codigo QR'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CustomTheme.redColor),
                    ),
                    onPressed: _onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar mesa'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _onUpdate,
                    icon: const Icon(Icons.update),
                    label: const Text('Actualizar mesa'),
                  ),
                  const SafeArea(bottom: false, child: SizedBox.shrink()),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _bodyController,
              child: ListView(
                padding: CustomTheme.drawerBodyPadding,
                controller: _bodyController,
                children: [
                  //TODO: Add table status
                  const SafeArea(bottom: false, child: SizedBox.shrink()),
                  const SectionTitle(title: 'Productos'),
                  const SafeArea(bottom: false, child: SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDownloadQr() async {
    final imgBytes = await WidgetToImg.capturePng(_qrKey);
    if (kIsWeb) {
      final stream = Stream.fromIterable(imgBytes);
      await download(stream, 'qr.png');
      return;
    }
    Share.shareXFiles(
      [XFile.fromData(imgBytes)],
      text: 'Codigo QR de la mesa ${widget.id}',
      subject: 'Codigo QR de la mesa ${widget.id}',
    );
  }

  void _onDelete() => ConfirmActionDialog.show(
        context: context,
        title: '¿Estas seguro de eliminar la mesa?',
        onConfirm: () {},
      );

  void _onUpdate() {}
}

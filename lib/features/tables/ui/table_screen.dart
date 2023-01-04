import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/widget_to_img.dart';
import 'package:oyt_front_table/modals/change_table_status_sheet.dart';
import 'package:oyt_front_table/models/tables_socket_response.dart';
import 'package:oyt_front_table/models/users_table.dart';
import 'package:oyt_front_table/widgets/call_to_waiter_card.dart';
import 'package:oyt_front_table/widgets/table_status_card.dart';
import 'package:oyt_front_widgets/drawer/drawer_layout.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';
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
  final _qrKey = GlobalKey();
  final _drawerController = ScrollController();
  final _bodyController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawerLayout(
        drawerWidth: 320,
        drawerChild: Scrollbar(
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(CustomTheme.redColor),
                ),
                onPressed: _onDelete,
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar mesa'),
              ),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                onPressed: _onUpdate,
                icon: const Icon(Icons.update),
                label: const Text('Actualizar mesa'),
              ),
              const SafeArea(bottom: false, child: SizedBox.shrink()),
            ],
          ),
        ),
        bodyChild: Scrollbar(
          controller: _bodyController,
          child: ListView(
            padding: CustomTheme.drawerBodyPadding,
            controller: _bodyController,
            children: [
              //TODO: Add table status
              const SafeArea(bottom: false, child: SizedBox.shrink()),
              const TableStatusCard(tableStatus: TableStatus.confirmOrder),
              const SizedBox(height: 10),
              CallToWaiterCard(
                needWaiter: false,
                onCallWaiter: (isCalling) {},
              ),
              const SizedBox(height: 10),
              //TODO: Show user list
              const Text('User list here'),
              const SizedBox(height: 10),
              CustomElevatedButton(
                onPressed: _onChangeStatus,
                child: const Text('Cambiar estado de la mesa'),
              ),
              const SafeArea(bottom: false, child: SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangeStatus() => ChangeTableStatusSheet.show(
        context: context,
        table: const TableResponse(id: '1', name: '1', status: TableStatus.confirmOrder),
        onTableStatusChanged: (status) {},
      );

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

import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_admin/features/tables/provider/table_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_core/utils/widget_to_img.dart';
import 'package:oyt_front_table/modals/change_table_status_sheet.dart';
import 'package:oyt_front_table/models/tables_socket_response.dart';
import 'package:oyt_front_table/widgets/table_status_card.dart';
import 'package:oyt_front_table/widgets/table_user_card.dart';
import 'package:oyt_front_widgets/drawer/drawer_layout.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/title/section_title.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:share_plus/share_plus.dart';

class TableScreen extends ConsumerStatefulWidget {
  const TableScreen({required this.table, super.key});

  static const route = '/table';

  final TableResponse table;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  final _tableName = TextEditingController();
  final _qrKey = GlobalKey();
  final _drawerController = ScrollController();
  final _bodyController = ScrollController();
  bool canUpdate = false;

  @override
  void initState() {
    _tableName.text = widget.table.name;
    _tableName.addListener(onUpdateText);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tableProvider.notifier).joinToTable(widget.table);
    });
    super.initState();
  }

  void onUpdateText() {
    if (!mounted) return;
    if (_tableName.text.trim() != widget.table.name) {
      canUpdate = true;
    } else {
      canUpdate = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tableState = ref.watch(tableProvider);
    final restaurantState = ref.watch(restaurantProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.read(tableProvider.notifier).leaveTable(widget.table);
        return true;
      },
      child: Scaffold(
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
                        'Mesa ${widget.table.name}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SectionTitle(title: 'Nombre de la mesa'),
                CustomTextField(label: 'Nombre de la mesa', controller: _tableName),
                const SectionTitle(title: 'Codigo QR de la mesa'),
                restaurantState.restaurant.on(
                  onData: (restaurant) => RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      decoration: CustomTheme.drawerBoxDecoration.copyWith(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          QrImage(data: widget.table.id),
                          Text(
                            restaurant.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                          const SizedBox(height: 2),
                          Text('Mesa ${widget.table.name}'),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  onError: (_) => const Center(child: Text('Error al cargar el restaurante')),
                  onLoading: () => const LoadingWidget(),
                  onInitial: () => const LoadingWidget(),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _onDownloadQr,
                  icon: const Icon(Icons.download),
                  label: const Text('Descargar codigo QR'),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(CustomTheme.redColor),
                  ),
                  onPressed: _onDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar mesa'),
                ),
                const SizedBox(height: 5),
                FilledButton.icon(
                  onPressed: canUpdate ? _onUpdateTable : null,
                  icon: const Icon(Icons.update),
                  label: const Text('Actualizar mesa'),
                ),
                const SafeArea(bottom: false, child: SizedBox.shrink()),
              ],
            ),
          ),
          bodyChild: tableState.tableUsers.on(
            onData: (data) => Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: _bodyController,
                    child: ListView(
                      controller: _bodyController,
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      children: [
                        TableStatusCard(tableStatus: data.tableStatus),
                        const SizedBox(height: 10),
                        ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: data.users.length,
                          itemBuilder: (context, index) {
                            final item = data.users[index];
                            return TableUserCard(userTable: item, showPrice: true, onEdit: null);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: onChangeStatus,
                  child: const Text('Cambiar estado de la mesa'),
                ),
                data.needsWaiter
                    ? TextButton(
                        onPressed: () =>
                            ref.read(tableProvider.notifier).stopCallingWaiter(widget.table.id),
                        child: const Text('Dejar de llamar al mesero'),
                      )
                    : TextButton(
                        onPressed: () =>
                            ref.read(tableProvider.notifier).callWaiter(widget.table.id),
                        child: const Text('Llamar al mesero'),
                      ),
                const SizedBox(height: 20),
              ],
            ),
            onError: (error) => Center(child: Text(error.message)),
            onLoading: () => const ScreenLoadingWidget(),
            onInitial: () => const Center(child: Text('La mesa esta vacia.')),
          ),
        ),
      ),
    );
  }

  void onChangeStatus() => ChangeTableStatusSheet.show(
        context: context,
        table: widget.table,
        onTableStatusChanged: (status) =>
            ref.read(tableProvider.notifier).changeStatus(status, widget.table),
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
      text: 'Codigo QR de la mesa ${widget.table.name}',
      subject: 'Codigo QR de la mesa ${widget.table.name}',
    );
  }

  void _onDelete() => ConfirmActionDialog.show(
        context: context,
        title: '¿Estas seguro de eliminar la mesa?',
        onConfirm: () {},
      );

  void _onUpdateTable() {
    ref
        .read(tableProvider.notifier)
        .updateTable(widget.table.copyWith(name: _tableName.text.trim()));
  }
}

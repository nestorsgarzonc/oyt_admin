import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_admin/features/tables/provider/table_provider.dart';
import 'package:oyt_admin/features/tables/ui/dialogs/add_table_dialog.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_admin/features/tables/ui/table_screen.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';
import 'package:oyt_front_widgets/cards/table_grid_card.dart';

class TablesTab extends ConsumerStatefulWidget {
  const TablesTab({super.key});

  @override
  ConsumerState<TablesTab> createState() => _TablesTabState();
}

class _TablesTabState extends ConsumerState<TablesTab> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final tableState = ref.watch(tableProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Mesas',
          subtitle:
              'Acá puedes ver las mesas del restaurante, editar las mesas, eliminar las mesas y agregar nuevas mesas.',
        ),
        AddButton(onTap: _onAddTable, text: 'Agregar mesa'),
        const Divider(),
        tableState.tables.on(
          onError: (error) => Center(child: Text(error.toString())),
          onLoading: () => const LoadingWidget(),
          onInitial: () => const LoadingWidget(),
          onData: (data) => Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: GridView.builder(
                itemCount: data.tables.length,
                controller: _scrollController,
                gridDelegate: TableGridCard.gridDelegate,
                itemBuilder: (context, index) {
                  final table = data.tables[index];
                  return TableGridCard(
                    item: table,
                    isCallingTable:
                        tableState.customerRequests.data?.callingTables.contains(table.id) ?? false,
                    onSelectTable: (item) =>
                        GoRouter.of(context).push(TableScreen.route, extra: table),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onAddTable() => AddTableDialog.show(context: context, onConfirm: () {});
}

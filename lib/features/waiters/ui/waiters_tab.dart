import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/waiters/models/waiter_model.dart';
import 'package:oyt_admin/features/waiters/provider/waiter_provider.dart';
import 'package:oyt_admin/features/waiters/ui/dialogs/waiter_detail_dialog.dart';
import 'package:oyt_front_widgets/error/not_found_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_admin/features/waiters/ui/dialogs/add_waiter_dialog.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class WaitersTab extends ConsumerStatefulWidget {
  const WaitersTab({super.key});

  @override
  ConsumerState<WaitersTab> createState() => _WaitersTabState();
}

class _WaitersTabState extends ConsumerState<WaitersTab> {
  final _scrollController = ScrollController();
  final _textEditingController = TextEditingController();
  String filter = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchWaiter(String query) {
    filter = query;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final waiterState = ref.watch(waiterProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Meseros',
          subtitle:
              'Acá puedes ver los meseros del restaurante, editar los meseros, eliminar meseros y agregar nuevos meseros.',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Buscar mesero',
                onChanged: _onSearchWaiter,
                prefixIcon: const Icon(Icons.search),
                controller: _textEditingController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            AddButton(onTap: _onAddWaiter, text: 'Agregar mesero'),
          ],
        ),
        const Divider(),
        Expanded(
          child: waiterState.waiters.on(
            onError: (error) => Center(child: Text(error.toString())),
            onLoading: () => const ScreenLoadingWidget(),
            onInitial: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(waiterProvider.notifier).getWaiters();
              });
              return const ScreenLoadingWidget();
            },
            onData: (waiters) {
              final filteredWaiters = waiters.where((waiter) => waiter.filter(filter)).toList();
              if (filteredWaiters.isEmpty) {
                return const NotFoundWidget(title: 'No se encontraron meseros');
              }
              return Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredWaiters.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: filteredWaiters[i].isAvailable
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      minLeadingWidth: 35,
                      onTap: () => _onTapWaiter(filteredWaiters[i]),
                      subtitle: Text('Correo: ${filteredWaiters[i].email}'),
                      title: Text('${filteredWaiters[i].firstName} ${filteredWaiters[i].lastName}'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onAddWaiter() => AddWaiterDialog.show(context: context);

  void _onTapWaiter(Waiter waiter) => WaiterDetailDialog.show(context: context, waiter: waiter);
}

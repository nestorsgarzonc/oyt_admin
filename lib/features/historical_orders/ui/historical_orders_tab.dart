import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/historical_orders/ui/modals/filter_historical_orders_modal.dart';
import 'package:oyt_admin/features/historical_orders/provider/historical_orders_provider.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';

class HistoricalOrdersTab extends ConsumerStatefulWidget {
  const HistoricalOrdersTab({super.key});

  @override
  ConsumerState<HistoricalOrdersTab> createState() => _HistoricalOrdersTab();
}

class _HistoricalOrdersTab extends ConsumerState<HistoricalOrdersTab> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final historicalOrdersState = ref.watch(historicalOrdersProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Historial de órdenes',
          subtitle: 'Acá puedes ver el historial de órdenes según los filtros que uses.',
        ),
        AddButton(text: 'Filtrar órdenes', icon: Icons.filter_list, onTap: _onFilterOrders),
        const Divider(),
        Expanded(
          child: historicalOrdersState.historicalOrders.on(
            onError: (err) => Center(child: Text(err.message)),
            onInitial: () => const Center(child: Text('No se ha hecho ninguna orden')),
            onLoading: () => const ScreenLoadingWidget(),
            onData: (data) => Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: data.orders.length,
                itemBuilder: (context, i) => Card(
                  child: ListTile(
                    onTap: () {},
                    title: Text('Orden $i'),
                    subtitle: Text('Fecha: ${data.orders[i].creationDate}'),
                    trailing: Text(
                      '\$${data.orders[i].totalPrice}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onFilterOrders() => FilterHistoricalOrdersDialog.show(context: context);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';
import 'package:oyt_admin/features/historical_orders/ui/modals/filter_historical_orders_modal.dart';
import 'package:oyt_admin/features/historical_orders/provider/historical_orders_provider.dart';
import 'package:oyt_admin/features/historical_orders/ui/filters_chips.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:lottie/lottie.dart';
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
  bool hasReachedFinal = false;
  int pageIndex = 1;

  HistoricalOrdersFilter? historicalOrdersFilter;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(historicalOrdersProvider.notifier).getHistoricalOrders(
          historicalOrdersFilter: historicalOrdersFilter, pageIndex: pageIndex);
      pageIndex++;
    });
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.maxScrollExtent - 100 < _scrollController.position.pixels) {
      ref.read(historicalOrdersProvider.notifier).getMoreHistoricalOrders(pageIndex: pageIndex);
      pageIndex++;
    }
  }

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
        FilterChips(
          historicalOrdersFilter: historicalOrdersFilter,
        ),
        Expanded(
          child: historicalOrdersState.historicalOrders.on(
            onError: (err) => err.message != 'No orders found'
                ? Center(child: Text(err.message))
                : Center(
                  child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 250,
                          width: 250,
                          child: Lottie.asset(
                            LottieAssets.notFound,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'No se han encontrado órdenes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                ),
            onInitial: () => const ScreenLoadingWidget(),
            onLoading: () => const ScreenLoadingWidget(),
            onData: (data) => data.orders.isNotEmpty
                ? Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: data.orders.length,
                      itemBuilder: (context, i) => Card(
                        child: ListTile(
                          onTap: () {},
                          title: Text('Orden $i'),
                          subtitle: Text('Fecha: ${data.orders[i].createdAt}'),
                          trailing: Text(
                            '\$${data.orders[i].totalPrice}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 250,
                        width: 250,
                        child: Lottie.asset(
                          LottieAssets.notFound,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'No se han encontrado órdenes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _onFilterOrders() => FilterHistoricalOrdersDialog.show(context: context);
}

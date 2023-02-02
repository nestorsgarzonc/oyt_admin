import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/orders_queue/orders_queue_provider.dart';
import 'package:oyt_admin/features/orders_queue/orders_queue_state.dart';
import 'package:oyt_front_orders_queue/models/orders_queue.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_front_widgets/dropdown/custom_dropdown_field.dart';
import 'package:oyt_front_orders_queue/models/order_status.dart';

class OrdersQueueTab extends ConsumerStatefulWidget {
  const OrdersQueueTab({super.key});

  @override
  ConsumerState<OrdersQueueTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<OrdersQueueTab> {
  OrderStatus? _selectedStatus;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ordersQueueState = ref.watch(ordersQueueProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Cola de productos',
          subtitle:
              'Acá puedes ver la cola de los productos y manejar los estados de los productos.',
        ),
        const SizedBox(height: 14),
        const Text(
          'Filtrar por:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: CustomDropdownField<OrderStatus>(
                items: OrderStatus.values,
                value: _selectedStatus,
                itemAsString: (item) => item.label,
                onChanged: (value) => setState(() => _selectedStatus = value),
                labelText: 'Estado del producto',
                hintText: 'Selecciona un estado',
              ),
            ),
            SizedBox(
              width: 100,
              child: TextButton(
                onPressed: onClean,
                child: const Text('Limpiar'),
              ),
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: ordersQueueState.ordersQueue.on(
            onError: (err) => Center(child: Text(err.message)),
            onLoading: () => const LoadingWidget(),
            onInitial: () => const Center(child: Text('No hay productos en cola')),
            onData: (data) {if (data.isEmpty) {
              return const Center(child: Text('No hay productos en cola'));
              }
              final filteredList = doFilter(_selectedStatus, data);
              return Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredList.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      horizontalTitleGap: 10,
                      title: Text('Producto: ${filteredList[i].productName}'),
                      subtitle: Text('Mesa: ${filteredList[i].tableName}'),
                      trailing: Text('Estado: \n${filteredList[i].estado}'),
                    ),
                  ),
                ),
              );},
          ),
        )
      ],
    );
  }

  void onClean () {
    _selectedStatus = null;
    setState(() {});
  }

  List<OrdersQueueModel> doFilter (OrderStatus? filter, List<OrdersQueueModel> data){
    if (filter == null) {
      return data;
    }
    final filteredList = data.where((e) => e.estado == filter.label).toList();
    return filteredList;
  }
}

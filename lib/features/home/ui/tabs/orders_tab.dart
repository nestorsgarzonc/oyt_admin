import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_front_widgets/dropdown/custom_dropdown_field.dart';

class OrdersQueueTab extends ConsumerStatefulWidget {
  const OrdersQueueTab({super.key});

  @override
  ConsumerState<OrdersQueueTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<OrdersQueueTab> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
        CustomDropdownField<String>(
          items: const ['all', 'pending', 'preparing', 'ready', 'delivered'],
          value: null,
          itemAsString: (item) => item,
          onChanged: (value) {},
          labelText: 'Estado del producto',
          hintText: 'Selecciona un estado',
        ),
        const Divider(),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 50,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () {},
                  title: Text('Producto $index'),
                  trailing: const Text('Estado: \nPendiente'),
                  subtitle: Text('Mesa: $index'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Cola de productos',
          subtitle:
              'Acá puedes ver la cola de los productos y manejar los estados de los productos.',
        ),
        AddButton(
          text: 'Filtrar ordenes',
          icon: Icons.filter_list,
          onTap: () {},
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
                  title: Text('Orden $index', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Fecha: 22-12-2022 12:12'),
                  trailing: const Text(
                    '\$100.000',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

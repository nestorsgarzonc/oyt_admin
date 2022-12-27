import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class CashierTab extends ConsumerStatefulWidget {
  const CashierTab({super.key});

  @override
  ConsumerState<CashierTab> createState() => _CashierTabState();
}

class _CashierTabState extends ConsumerState<CashierTab> {
  final _scrollController = ScrollController();
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchWaiter(String query) {
    Logger.log('Searching waiter: $query');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Cajeros',
          subtitle:
              'Acá puedes ver los cajeros del restaurante, editar los cajeros, eliminar cajeros y agregar nuevos cajeros.',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Buscar cajero',
                onChanged: _onSearchWaiter,
                prefixIcon: const Icon(Icons.search),
                controller: _textEditingController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            AddButton(onTap: _onAddWaiter, text: 'Agregar cajero'),
          ],
        ),
        const Divider(),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 20,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () => _onTapWaiter(),
                  subtitle: Text('Correo: $index'),
                  title: Text('Cajero $index'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onAddWaiter() {}

  void _onTapWaiter() {}
}

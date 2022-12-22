import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';

class WaitersTab extends ConsumerStatefulWidget {
  const WaitersTab({super.key});

  @override
  ConsumerState<WaitersTab> createState() => _WaitersTabState();
}

class _WaitersTabState extends ConsumerState<WaitersTab> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Meseros',
          subtitle:
              'Aca puedes ver los meseros del restaurante, editar los meseros, eliminar meseros y agregar nuevos meseros.',
        ),
        AddButton(onTap: _onAddWaiter, text: 'Agregar mesero'),
        const Divider(),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () => _onTapWaiter(),
                    title: Text('Mesero $index'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onAddWaiter() {}

  void _onTapWaiter() {}
}

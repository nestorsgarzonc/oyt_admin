import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';

class TablesTab extends ConsumerStatefulWidget {
  const TablesTab({super.key});

  @override
  ConsumerState<TablesTab> createState() => _TablesTabState();
}

class _TablesTabState extends ConsumerState<TablesTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Mesas',
          subtitle:
              'Aca puedes ver las mesas del restaurante, editar las mesas, eliminar las mesas y agregar nuevas mesas.',
        ),
        AddButton(onTap: _onAddTable, text: 'Agregar mesa'),
        const Divider(),
      ],
    );
  }

  void _onAddTable() {}
}

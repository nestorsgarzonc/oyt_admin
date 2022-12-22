import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';

class InventoryTab extends ConsumerStatefulWidget {
  const InventoryTab({super.key});

  @override
  ConsumerState<InventoryTab> createState() => _InventoryTab();
}

class _InventoryTab extends ConsumerState<InventoryTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Inventario',
          subtitle:
              'Acá puedes ver los meseros del restaurante, editar los meseros, eliminar meseros y agregar nuevos meseros.',
        ),
      ],
    );
  }
}

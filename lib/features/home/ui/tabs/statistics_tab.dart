import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';

class StatisticsTab extends ConsumerStatefulWidget {
  const StatisticsTab({super.key});

  @override
  ConsumerState<StatisticsTab> createState() => _StatisticsTab();
}

class _StatisticsTab extends ConsumerState<StatisticsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Estadísticas',
          subtitle:
              'Acá puedes ver los meseros del restaurante, editar los meseros, eliminar meseros y agregar nuevos meseros.',
        ),
      ],
    );
  }
}

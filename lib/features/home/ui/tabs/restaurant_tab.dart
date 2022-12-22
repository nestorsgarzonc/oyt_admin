import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';

class RestaurantTab extends ConsumerStatefulWidget {
  const RestaurantTab({super.key});

  @override
  ConsumerState<RestaurantTab> createState() => _RestaurantTab();
}

class _RestaurantTab extends ConsumerState<RestaurantTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Restaurante',
          subtitle:
              'Acá puedes ver los meseros del restaurante, editar los meseros, eliminar meseros y agregar nuevos meseros.',
        ),
      ],
    );
  }
}

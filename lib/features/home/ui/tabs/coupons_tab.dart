import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';

class CouponsTab extends ConsumerStatefulWidget {
  const CouponsTab({super.key});

  @override
  ConsumerState<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends ConsumerState<CouponsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Cupones',
          subtitle:
              'Acá puedes ver los meseros del restaurante, editar los meseros, eliminar meseros y agregar nuevos meseros.',
        ),
      ],
    );
  }
}

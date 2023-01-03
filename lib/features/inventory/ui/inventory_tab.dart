import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';

class InventoryTab extends ConsumerStatefulWidget {
  const InventoryTab({super.key});

  @override
  ConsumerState<InventoryTab> createState() => _InventoryTab();
}

class _InventoryTab extends ConsumerState<InventoryTab> {
  final _categoriesScrollController = ScrollController();
  final _productsScrollController = ScrollController();
  final _toppingsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Inventario',
          subtitle:
              'Acá puedes ver el inventario del restaurante, editar el numero de unidades disponibles y cambiar la disponibilidad de los productos.',
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: _categoriesScrollController,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    controller: _categoriesScrollController,
                    children: [
                      const Text('Categorías', style: CustomTheme.sectionTitleStyle),
                      ...List.generate(
                        20,
                        (index) => Card(
                          key: Key('$index'),
                          margin: CustomTheme.cardMargin,
                          elevation: index == 2 ? 3 : null,
                          child: ListTile(
                            selected: index == 2,
                            title: Text(
                              'Categoria $index',
                              style: index == 2 ? CustomTheme.selectedItemTextStyle : null,
                            ),
                            onTap: () => _onSelectCategory(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Scrollbar(
                  controller: _productsScrollController,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    controller: _productsScrollController,
                    children: [
                      const Text('Productos', style: CustomTheme.sectionTitleStyle),
                      ...List.generate(
                        20,
                        (index) => Card(
                          key: Key('$index'),
                          margin: CustomTheme.cardMargin,
                          elevation: index == 3 ? 3 : null,
                          child: ListTile(
                            selected: index == 3,
                            title: Text(
                              'Producto $index',
                              style: index == 3 ? CustomTheme.selectedItemTextStyle : null,
                            ),
                            onTap: () => _onSelectProduct(),
                            trailing: IconButton(
                              onPressed: () => _onEditProduct(),
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Scrollbar(
                  controller: _toppingsScrollController,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    controller: _toppingsScrollController,
                    children: [
                      const Text('Toppings', style: CustomTheme.sectionTitleStyle),
                      ...List.generate(
                        20,
                        (index) => Card(
                          key: Key('$index'),
                          margin: CustomTheme.cardMargin,
                          child: ListTile(
                            onTap: () => _onEditTopping(),
                            title: Text('Topping $index'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSelectCategory() {}
  void _onSelectProduct() {}

  void _onEditProduct() {}
  void _onEditTopping() {}
}

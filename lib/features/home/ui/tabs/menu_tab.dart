import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/ui/widgets/tab_header.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_category_dialog.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_product_dialog.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_topping_dialog.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';

class MenuTab extends ConsumerStatefulWidget {
  const MenuTab({super.key});

  @override
  ConsumerState<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends ConsumerState<MenuTab> {
  static const _sectionTitleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  static const _cardMargin = EdgeInsets.symmetric(vertical: 5);
  static const _selectedItemTextStyle =
      TextStyle(fontWeight: FontWeight.w600, color: Colors.deepOrange);

  final _categoriesScrollController = ScrollController();
  final _productsScrollController = ScrollController();
  final _toppingsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Menú',
          subtitle: 'Acá puedes ver el menú del restaurante, editar y agregar productos.',
        ),
        const Divider(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: _categoriesScrollController,
                  child: ReorderableListView(
                    padding: EdgeInsets.zero,
                    scrollController: _categoriesScrollController,
                    onReorder: _onReorderCategories,
                    children: [
                      const Text(
                        'Categorías',
                        style: _sectionTitleStyle,
                        key: Key('categoriesTitle'),
                      ),
                      AddButton(
                        onTap: _onAddCategory,
                        text: 'Agregar categoria',
                        buttonType: ButtonType.outlined,
                        key: const Key('addCategoryButton'),
                      ),
                      ...List.generate(
                        20,
                        (index) => Card(
                          key: Key('$index'),
                          margin: _cardMargin,
                          elevation: index == 2 ? 3 : null,
                          child: ListTile(
                            selected: index == 2,
                            title: Text(
                              'Categoria $index',
                              style: index == 2 ? _selectedItemTextStyle : null,
                            ),
                            trailing: IconButton(
                              onPressed: () => _onEditCategory(),
                              icon: const Icon(Icons.edit),
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
                  child: ReorderableListView(
                    padding: EdgeInsets.zero,
                    onReorder: _onReorderProducts,
                    scrollController: _productsScrollController,
                    children: [
                      const Text(
                        'Productos',
                        style: _sectionTitleStyle,
                        key: Key('productsTitle'),
                      ),
                      AddButton(
                        key: const Key('addProductButton'),
                        onTap: _onAddProduct,
                        text: 'Agregar producto',
                        buttonType: ButtonType.outlined,
                      ),
                      ...List.generate(
                        20,
                        (index) => Card(
                          key: Key('$index'),
                          margin: _cardMargin,
                          elevation: index == 3 ? 3 : null,
                          child: ListTile(
                            selected: index == 3,
                            title: Text(
                              'Producto $index',
                              style: index == 3 ? _selectedItemTextStyle : null,
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
                  child: ReorderableListView(
                    padding: EdgeInsets.zero,
                    scrollController: _toppingsScrollController,
                    onReorder: _onReorderToppings,
                    children: [
                      const Text(
                        'Toppings',
                        style: _sectionTitleStyle,
                        key: Key('toppingsTitle'),
                      ),
                      AddButton(
                        onTap: _onAddTopping,
                        text: 'Agregar topping',
                        buttonType: ButtonType.outlined,
                        key: const Key('addToppingButton'),
                      ),
                      ...List.generate(
                        20,
                        (index) => Card(
                          key: Key('$index'),
                          margin: _cardMargin,
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

  void _onReorderCategories(int oldIndex, int newIndex) {
    if (oldIndex <= 1) return;
    oldIndex -= 2;
    newIndex -= 2;
  }

  void _onReorderProducts(int oldIndex, int newIndex) {
    if (oldIndex <= 1) return;
    oldIndex -= 2;
    newIndex -= 2;
  }

  void _onReorderToppings(int oldIndex, int newIndex) {
    if (oldIndex <= 1) return;
    oldIndex -= 2;
    newIndex -= 2;
  }

  void _onAddCategory() => AddCategoryDialog.show(context: context);
  void _onAddProduct() => AddProductDialog.show(context: context);
  void _onAddTopping() => AddToppingDialog.show(context: context);

  void _onSelectCategory() {}
  void _onSelectProduct() {}

  void _onEditCategory() {}
  void _onEditProduct() {}
  void _onEditTopping() {}
}

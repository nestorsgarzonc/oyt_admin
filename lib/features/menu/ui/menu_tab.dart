import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/product/provider/product_provider.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_menu/ui/widgets/menu_item_card.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_category_dialog.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_product_dialog.dart';
import 'package:oyt_admin/features/menu/ui/dialogs/add_topping_dialog.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';

class MenuTab extends ConsumerWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantState = ref.watch(restaurantProvider);
    return restaurantState.restaurant.on(
      onError: (error) => Text(error.toString()),
      onLoading: () => const ScreenLoadingWidget(),
      onInitial: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(restaurantProvider.notifier).getRestaurant();
        });
        return const ScreenLoadingWidget();
      },
      onData: (restaurant) => MenuTabBody(restaurant: restaurant),
    );
  }
}

class MenuTabBody extends ConsumerStatefulWidget {
  const MenuTabBody({required this.restaurant, super.key});

  final RestaurantModel? restaurant;

  @override
  ConsumerState<MenuTabBody> createState() => _MenuTabBodyState();
}

class _MenuTabBodyState extends ConsumerState<MenuTabBody> {
  final _categoriesScrollController = ScrollController();
  final _productsScrollController = ScrollController();
  final _toppingsScrollController = ScrollController();
  Menu? selectedCategory;
  MenuItem? selectedProduct;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Menú',
          subtitle: 'Acá puedes ver el menú del restaurante, editar y agregar productos.',
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: _categoriesScrollController,
                  child: ReorderableListView(
                    buildDefaultDragHandles: false,
                    padding: EdgeInsets.zero,
                    scrollController: _categoriesScrollController,
                    onReorder: _onReorderCategories,
                    children: [
                      const Text(
                        'Categorías',
                        style: CustomTheme.sectionTitleStyle,
                        key: Key('categoriesTitle'),
                      ),
                      AddButton(
                        onTap: _onAddCategory,
                        text: 'Agregar categoria',
                        buttonType: ButtonType.outlined,
                        key: const Key('addCategoryButton'),
                      ),
                      ...List.generate(
                        widget.restaurant?.categories.length ?? 0,
                        (index) {
                          final item = widget.restaurant!.categories[index];
                          return MenuItemCard(
                            isSelected: item == selectedCategory,
                            title: item.name,
                            onTap: () => _onSelectCategory(item),
                            onEdit: () => _onEditCategory(item),
                            leading: ReorderableDragStartListener(
                              index: index + 2,
                              child: const Icon(Icons.drag_indicator_outlined),
                            ),
                            key: Key(item.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              selectedCategory == null
                  ? const Center(child: Text('Selecciona una categoria para ver los productos...'))
                  : Expanded(
                      child: Scrollbar(
                        controller: _productsScrollController,
                        child: ReorderableListView(
                          padding: EdgeInsets.zero,
                          buildDefaultDragHandles: false,
                          onReorder: _onReorderProducts,
                          scrollController: _productsScrollController,
                          children: [
                            const Text(
                              'Productos',
                              style: CustomTheme.sectionTitleStyle,
                              key: Key('productsTitle'),
                            ),
                            AddButton(
                              key: const Key('addProductButton'),
                              onTap: () => _onAddProduct(selectedCategory!),
                              text: 'Agregar producto',
                              buttonType: ButtonType.outlined,
                            ),
                            ...List.generate(
                              selectedCategory!.menuItems.length,
                              (index) {
                                final item = selectedCategory!.menuItems[index];
                                return MenuItemCard(
                                  isSelected: item == selectedProduct,
                                  title: item.name,
                                  onTap: () => _onSelectProduct(item),
                                  leading: ReorderableDragStartListener(
                                    index: index + 2,
                                    child: const Icon(Icons.drag_indicator_outlined),
                                  ),
                                  key: Key(item.id),
                                  onEdit: () => _onEditProduct(item, selectedCategory!),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              if (selectedCategory != null) const VerticalDivider(),
              if (selectedCategory != null)
                selectedProduct == null
                    ? const Center(child: Text('Selecciona un producto para ver los toppings...'))
                    : Expanded(
                        child: productState.productDetail.on(
                          onError: (error) => Center(child: Text(error.message)),
                          onLoading: () => const LoadingWidget(),
                          onInitial: () => const LoadingWidget(),
                          onData: (product) => Scrollbar(
                            controller: _toppingsScrollController,
                            child: ReorderableListView(
                              padding: EdgeInsets.zero,
                              buildDefaultDragHandles: false,
                              scrollController: _toppingsScrollController,
                              onReorder: _onReorderToppings,
                              children: [
                                const Text(
                                  'Toppings',
                                  style: CustomTheme.sectionTitleStyle,
                                  key: Key('toppingsTitle'),
                                ),
                                AddButton(
                                  onTap: () => _onAddTopping(selectedProduct!),
                                  text: 'Agregar topping',
                                  buttonType: ButtonType.outlined,
                                  key: const Key('addToppingButton'),
                                ),
                                ...List.generate(
                                  product.toppings.length,
                                  (index) {
                                    final item = product.toppings[index];
                                    return MenuItemCard(
                                      isSelected: item == selectedCategory,
                                      title: item.name,
                                      onTap: () => _onEditTopping(item, selectedProduct!),
                                      onEdit: () => _onEditTopping(item, selectedProduct!),
                                      leading: ReorderableDragStartListener(
                                        index: index + 2,
                                        child: const Icon(Icons.drag_indicator_outlined),
                                      ),
                                      key: Key(item.id),
                                    );
                                  },
                                ),
                              ],
                            ),
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
  void _onAddProduct(Menu category) async {
    await AddProductDialog.show(context: context, category: category);
    _onSelectCategory(null);
  }

  void _onAddTopping(MenuItem menuItem) async {
    await AddToppingDialog.show(context: context, menuItem: menuItem);
    if (selectedProduct != null) {
      ref.read(productProvider.notifier).productDetail(selectedProduct!.id);
    }
  }

  void _onSelectCategory(Menu? category) {
    selectedCategory = category;
    selectedProduct = null;
    setState(() {});
  }

  void _onSelectProduct(MenuItem product) {
    selectedProduct = product;
    ref.read(productProvider.notifier).productDetail(product.id);
  }

  void _onEditCategory(Menu item) => AddCategoryDialog.show(context: context, categoryItem: item);
  void _onEditProduct(MenuItem product, Menu category) async {
    await AddProductDialog.show(context: context, menuItem: product, category: category);
    _onSelectCategory(null);
  }

  void _onEditTopping(Topping item, MenuItem menuItem) async {
    await AddToppingDialog.show(context: context, toppingItem: item, menuItem: menuItem);
    if (selectedProduct != null) {
      ref.read(productProvider.notifier).productDetail(selectedProduct!.id);
    }
  }
}

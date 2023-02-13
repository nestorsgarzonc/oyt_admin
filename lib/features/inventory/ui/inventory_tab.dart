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

class InventoryTab extends ConsumerWidget {
  const InventoryTab({super.key});

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
      onData: (restaurant) => InventoryTabBody(restaurant: restaurant),
    );
  }
}

class InventoryTabBody extends ConsumerStatefulWidget {
  const InventoryTabBody({required this.restaurant, super.key});

  final RestaurantModel? restaurant;

  @override
  ConsumerState<InventoryTabBody> createState() => _InventoryTabBody();
}

class _InventoryTabBody extends ConsumerState<InventoryTabBody> {
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
                      const Text(
                        'Categorías',
                        style: CustomTheme.sectionTitleStyle,
                        key: Key('categoriesTitle'),
                      ),
                      ...List.generate(
                        widget.restaurant?.categories.length ?? 0,
                        (index) {
                          final item = widget.restaurant!.categories[index];
                          return MenuItemCard(
                            isSelected: item == selectedCategory,
                            title: item.name,
                            onTap: () => _onSelectCategory(item),
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
                        child: ListView(
                          padding: EdgeInsets.zero,
                          controller: _productsScrollController,
                          children: [
                            const Text(
                              'Productos',
                              style: CustomTheme.sectionTitleStyle,
                              key: Key('productsTitle'),
                            ),
                            ...List.generate(
                              selectedCategory!.menuItems.length,
                              (index) {
                                final item = selectedCategory!.menuItems[index];
                                return MenuItemCard(
                                  isSelected: item == selectedProduct,
                                  title: item.name,
                                  onTap: () => _onSelectProduct(item),
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
                            child: ListView(
                              padding: EdgeInsets.zero,
                              controller: _toppingsScrollController,
                              children: [
                                const Text(
                                  'Toppings',
                                  style: CustomTheme.sectionTitleStyle,
                                  key: Key('toppingsTitle'),
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

  void _onSelectCategory(Menu? category) {
    selectedCategory = category;
    selectedProduct = null;
    setState(() {});
  }

  void _onSelectProduct(MenuItem product) {
    selectedProduct = product;
    ref.read(productProvider.notifier).productDetail(product.id);
  }

  void _onEditProduct(MenuItem product, Menu category) async {
    _onSelectCategory(null);
  }

  void _onEditTopping(Topping item, MenuItem menuItem) async {}
}

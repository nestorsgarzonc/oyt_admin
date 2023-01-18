import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/product/provider/product_provider.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';
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
  late RestaurantModel? restaurant;
  Menu? selectedCategory;
  MenuItem? selectedProduct;

  @override
  void initState() {
    restaurant = widget.restaurant;
    super.initState();
  }

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
                        restaurant?.categories.length ?? 0,
                        (index) {
                          final item = restaurant!.categories[index];
                          return Card(
                            key: Key(item.id),
                            margin: CustomTheme.cardMargin,
                            elevation: item == selectedCategory ? 3 : null,
                            child: ListTile(
                              selected: item == selectedCategory,
                              leading: ReorderableDragStartListener(
                                index: index + 2,
                                child: const Icon(Icons.drag_indicator_outlined),
                              ),
                              title: Text(
                                item.name,
                                style: item == selectedCategory
                                    ? CustomTheme.selectedItemTextStyle
                                    : null,
                              ),
                              trailing: IconButton(
                                onPressed: () => _onEditCategory(item),
                                icon: const Icon(Icons.edit),
                              ),
                              onTap: () => _onSelectCategory(item),
                            ),
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
                              onTap: _onAddProduct,
                              text: 'Agregar producto',
                              buttonType: ButtonType.outlined,
                            ),
                            ...List.generate(
                              selectedCategory!.menuItems.length,
                              (index) {
                                final item = selectedCategory!.menuItems[index];
                                return Card(
                                  key: Key(item.id),
                                  margin: CustomTheme.cardMargin,
                                  elevation: selectedProduct == item ? 3 : null,
                                  child: ListTile(
                                    selected: selectedProduct == item,
                                    leading: ReorderableDragStartListener(
                                      index: index + 2,
                                      child: const Icon(Icons.drag_indicator_outlined),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: selectedProduct == item
                                          ? CustomTheme.selectedItemTextStyle
                                          : null,
                                    ),
                                    onTap: () => _onSelectProduct(item),
                                    trailing: IconButton(
                                      onPressed: () => _onEditProduct(item),
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
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
                                  onTap: _onAddTopping,
                                  text: 'Agregar topping',
                                  buttonType: ButtonType.outlined,
                                  key: const Key('addToppingButton'),
                                ),
                                ...List.generate(
                                  product.toppings.length,
                                  (index) {
                                    final item = product.toppings[index];
                                    return Card(
                                      key: Key(item.id),
                                      margin: CustomTheme.cardMargin,
                                      child: ListTile(
                                        leading: ReorderableDragStartListener(
                                          index: index + 2,
                                          child: const Icon(Icons.drag_indicator_outlined),
                                        ),
                                        onTap: () => _onEditTopping(item),
                                        title: Text(item.name),
                                      ),
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
  void _onAddProduct() => AddProductDialog.show(context: context);
  void _onAddTopping() => AddToppingDialog.show(context: context);

  void _onSelectCategory(Menu category) {
    selectedCategory = category;
    selectedProduct = null;
    setState(() {});
  }

  void _onSelectProduct(MenuItem product) {
    selectedProduct = product;
    ref.read(productProvider.notifier).productDetail(product.id);
  }

  void _onEditCategory(Menu item) => AddCategoryDialog.show(context: context, categoryItem: item);
  void _onEditProduct(MenuItem product) =>
      AddProductDialog.show(context: context, menuItem: product);
  void _onEditTopping(Topping item) => AddToppingDialog.show(context: context, toppingItem: item);
}

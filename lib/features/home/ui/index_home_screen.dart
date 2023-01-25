import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/auth/provider/auth_provider.dart';
import 'package:oyt_admin/features/inventory/ui/inventory_tab.dart';
import 'package:oyt_admin/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_widgets/drawer/drawer_layout.dart';
import 'package:oyt_front_widgets/drawer/models/drawer_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oyt_admin/features/cashier/ui/cashier_tab.dart';
import 'package:oyt_admin/features/historical_orders/ui/historical_orders_tab.dart';
import 'package:oyt_admin/features/menu/ui/menu_tab.dart';
import 'package:oyt_admin/features/orders/ui/orders_tab.dart';
import 'package:oyt_admin/features/restaurant/ui/restaurant_tab.dart';
import 'package:oyt_admin/features/statistics/ui/statistics_tab.dart';
import 'package:oyt_admin/features/tables/ui/tables_tab.dart';
import 'package:oyt_admin/features/waiters/ui/waiters_tab.dart';
import 'package:oyt_front_widgets/drawer/drawer_item_card.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';

class IndexHomeScreen extends ConsumerStatefulWidget {
  const IndexHomeScreen({super.key});

  static const route = '/home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndexHomeScreenState();
}

class _IndexHomeScreenState extends ConsumerState<IndexHomeScreen> {
  int _index = 1;
  final _scrollController = ScrollController();

  static final _items = [
    CardItem(
      title: 'Restaurante',
      icon: FontAwesomeIcons.utensils,
      tab: () => const RestaurantTab(),
    ),
    CardItem(
      title: 'Mesas',
      icon: Icons.table_bar,
      tab: () => const TablesTab(),
    ),
    CardItem(
      title: 'Menú',
      icon: Icons.menu_book_rounded,
      tab: () => const MenuTab(),
    ),
    CardItem(
      title: 'Cola de productos',
      icon: FontAwesomeIcons.burger,
      tab: () => const OrdersQueueTab(),
    ),
    CardItem(
      title: 'Historial de ordenes',
      icon: FontAwesomeIcons.fileLines,
      tab: () => const HistoricalOrdersTab(),
    ),
    CardItem(
      title: 'Meseros',
      icon: FontAwesomeIcons.userTie,
      tab: () => const WaitersTab(),
    ),
    CardItem(
      title: 'Cajeros',
      icon: FontAwesomeIcons.cashRegister,
      tab: () => const CashierTab(),
    ),
    CardItem(
      title: 'Estadísticas',
      icon: FontAwesomeIcons.chartArea,
      tab: () => const StatisticsTab(),
    ),
    CardItem(
      title: 'Inventario',
      icon: FontAwesomeIcons.boxesStacked,
      tab: () => const InventoryTab(),
    ),
    //CardItem(
    //  title: 'Cupones',
    //  icon: FontAwesomeIcons.ticket,
    //  tab: () => const CouponsTab(),
    //),
  ];

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    return Scaffold(
      body: restaurantState.restaurant.on(
        onError: (error) => Center(child: Text(error.toString())),
        onLoading: () => const ScreenLoadingWidget(),
        onInitial: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(restaurantProvider.notifier).getRestaurant();
          });
          return const ScreenLoadingWidget();
        },
        onData: (restaurant) => DrawerLayout(
          drawerChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SafeArea(child: SizedBox.shrink()),
              restaurant.imageUrl == null
                  ? const SizedBox.shrink()
                  : ImageApi(restaurant.logoUrl!, width: 150, fit: BoxFit.fitWidth),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _items.length,
                    itemBuilder: (context, index) => DrawerItemCard(
                      item: _items[index],
                      onTap: () => setState(() => _index = index),
                      isSelected: _index == index,
                    ),
                  ),
                ),
              ),
              DrawerItemCard(
                onTap: ref.read(authProvider.notifier).logout,
                item: CardItem(
                  title: 'Cerrar sesión',
                  icon: Icons.logout,
                  tab: () => const SizedBox(),
                ),
                isSelected: false,
              ),
              const SafeArea(child: SizedBox.shrink()),
            ],
          ),
          bodyChild: _items[_index].tab(),
        ),
      ),
    );
  }
}

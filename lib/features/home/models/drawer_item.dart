import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oyt_admin/features/home/ui/tabs/cashier_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/historical_orders_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/menu_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/orders_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/restaurant_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/statistics_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/tables_tab.dart';
import 'package:oyt_admin/features/home/ui/tabs/waiters_tab.dart';

class CardItem extends Equatable {
  const CardItem({required this.title, required this.icon, required this.tab});

  final String title;
  final IconData icon;
  final Widget Function() tab;

  @override
  List<Object> get props => [title, icon];

  static final items = [
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
      title: 'Histórico ordenes',
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
    //CardItem(
    //  title: 'Inventario',
    //  icon: FontAwesomeIcons.boxesStacked,
    //  tab: () => const InventoryTab(),
    //),
    //CardItem(
    //  title: 'Cupones',
    //  icon: FontAwesomeIcons.ticket,
    //  tab: () => const CouponsTab(),
    //),
  ];
}

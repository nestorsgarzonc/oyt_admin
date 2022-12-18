import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardItem extends Equatable {
  const CardItem({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  List<Object> get props => [title, icon];

  static const items = [
    CardItem(title: 'Mesas', icon: Icons.table_bar),
    CardItem(title: 'Menu', icon: Icons.menu_book_rounded),
    CardItem(title: 'Pedidos', icon: FontAwesomeIcons.burger),
    CardItem(title: 'Historico ordenes', icon: FontAwesomeIcons.fileLines),
    CardItem(title: 'Meseros', icon: FontAwesomeIcons.userTie),
    CardItem(title: 'Restaurante', icon: FontAwesomeIcons.building),
    CardItem(title: 'Estadisticas', icon: FontAwesomeIcons.chartArea),
    CardItem(title: 'Inventario', icon: FontAwesomeIcons.boxesStacked),
    CardItem(title: 'Cupones', icon: FontAwesomeIcons.ticket),
  ];
}

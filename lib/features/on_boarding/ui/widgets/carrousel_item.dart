import 'package:flutter/material.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:lottie/lottie.dart';
import 'package:equatable/equatable.dart';

class CarrouselItemModel extends Equatable {
  const CarrouselItemModel(this.message, this.lottieAsset);

  final String message;
  final String lottieAsset;

  static const items = [
    CarrouselItemModel(
      'Administra tu restaurante desde cualquier parte del mundo en tiempo real tan solo con tu computador e internet.',
      LottieAssets.adminFancy,
    ),
    CarrouselItemModel(
      'Maneja tus meseros, cocineros, cajeros desde solo un lugar.',
      LottieAssets.adminCrm,
    ),
    CarrouselItemModel(
      'Lo que no se mide no se mejora!\nPor ello maneja todas los datos clave de tu restaurante en al modulo de analitica.',
      LottieAssets.analytics,
    ),
    CarrouselItemModel(
      'Gestiona los pedidos entrantes y su estado de preparacion.',
      LottieAssets.chefPreparingFood,
    ),
    CarrouselItemModel(
      'Maneja el inventario de cada uno de tus productos.',
      LottieAssets.truckLeavingMerch,
    ),
    CarrouselItemModel(
      'Evitar papeleos y tener datos en tiempo real de tu restaurante.',
      LottieAssets.admin,
    ),
  ];

  @override
  List<Object?> get props => [message, lottieAsset];
}

class CarrouselItem extends StatelessWidget {
  const CarrouselItem({Key? key, required this.item}) : super(key: key);

  final CarrouselItemModel item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              item.lottieAsset,
              fit: BoxFit.contain,
              height: constraints.maxHeight * 0.86,
              width: constraints.maxWidth,
            ),
            Text(
              item.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }
}

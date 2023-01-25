import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:oyt_admin/features/on_boarding/ui/widgets/carrousel_item.dart';
import 'package:oyt_admin/features/restaurant/ui/register_restaurant_screen.dart';
import 'package:oyt_front_widgets/widgets/backgrounds/animated_background.dart';

class OnBoardingAdminScreen extends StatefulWidget {
  const OnBoardingAdminScreen({super.key});

  static const route = '/on-boarding';

  @override
  State<OnBoardingAdminScreen> createState() => _OnBoardingAdminScreenState();
}

class _OnBoardingAdminScreenState extends State<OnBoardingAdminScreen> {
  final scrollController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    scrollController.addListener(onPageChanged);
    autoChangePage();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onPageChanged);
    scrollController.dispose();
    super.dispose();
  }

  void autoChangePage() {
    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (currentIndex == CarrouselItemModel.items.length - 1) {
        scrollController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } else {
        scrollController.animateToPage(
          currentIndex + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void onPageChanged() {
    if (scrollController.page == null) return;
    if (currentIndex == scrollController.page!.round()) return;
    setState(() {
      currentIndex = scrollController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBackground(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Bienvenido al administrador',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Con On Your Table podras',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: size.height * 0.6,
            child: PageView.builder(
              controller: scrollController,
              itemCount: CarrouselItemModel.items.length,
              itemBuilder: (context, index) => CarrouselItem(
                item: CarrouselItemModel.items[index],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              CarrouselItemModel.items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 10,
                width: currentIndex == index ? 20 : 10,
                decoration: BoxDecoration(
                  color: currentIndex == index ? Colors.deepOrange : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: onContinue, child: const Text('Continuar')),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void onContinue() {
    GoRouter.of(context).pushReplacement(RegisterRestaurant.route);
  }
}

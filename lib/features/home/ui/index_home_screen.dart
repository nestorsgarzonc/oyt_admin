import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/models/drawer_item.dart';
import 'package:oyt_admin/features/home/ui/widgets/drawer_item_card.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';

class IndexHomeScreen extends ConsumerStatefulWidget {
  const IndexHomeScreen({super.key});

  static const route = '/home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndexHomeScreenState();
}

class _IndexHomeScreenState extends ConsumerState<IndexHomeScreen> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: CustomTheme.drawerBoxDecoration,
                  padding: const EdgeInsets.all(15),
                  width: 200,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SafeArea(child: SizedBox.shrink()),
                      const ImageApi(
                        'https://i0.wp.com/takuma.com.co/wp-content/uploads/2021/06/2021-logo.png',
                        width: 185,
                        fit: BoxFit.fitWidth,
                      ),
                      const Spacer(),
                      ...CardItem.items.asMap().entries.map(
                            (entry) => DrawerItemCard(
                              item: entry.value,
                              onTap: () => setState(() => _index = entry.key),
                              isSelected: _index == entry.key,
                            ),
                          ),
                      const Spacer(),
                      DrawerItemCard(
                        onTap: () {},
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
                ),
                Expanded(
                  child: SafeArea(
                    minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: CardItem.items[_index].tab(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

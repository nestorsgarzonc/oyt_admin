import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/home/models/drawer_item.dart';
import 'package:oyt_admin/features/home/ui/widgets/drawer_item_card.dart';

class IndexHomeScreen extends ConsumerStatefulWidget {
  const IndexHomeScreen({super.key});

  static const route = '/home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndexHomeScreenState();
}

class _IndexHomeScreenState extends ConsumerState<IndexHomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  padding: const EdgeInsets.all(15),
                  width: 200,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SafeArea(child: SizedBox.shrink()),
                      const FlutterLogo(size: 70),
                      const SizedBox(height: 10),
                      const Text(
                        'Restaurant name',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: IndexedStack(
                    index: _index,
                    children: CardItem.items.map((e) => e.tab()).toList(),
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

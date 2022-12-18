import 'package:flutter/material.dart';
import 'package:oyt_admin/features/home/models/drawer_item.dart';

class DrawerItemCard extends StatelessWidget {
  const DrawerItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.isSelected,
  });

  final CardItem item;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepOrange : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 10)] : null,
        border: isSelected ? null : Border.all(color: Colors.black12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? Colors.white : Colors.deepOrange.withOpacity(0.8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

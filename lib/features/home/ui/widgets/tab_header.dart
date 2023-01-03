import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        Text(subtitle),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

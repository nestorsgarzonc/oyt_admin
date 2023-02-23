import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';

class ChefDetailDialog extends ConsumerStatefulWidget {
  const ChefDetailDialog({super.key, required this.chef});

  final Chef chef;

  static Future<void> show({required BuildContext context, required Chef chef}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ChefDetailDialog(chef: chef),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChefDetailDialogState();
}

class _ChefDetailDialogState extends ConsumerState<ChefDetailDialog> {
  @override
  //TODO: CONTINUE
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';
import 'package:oyt_admin/features/chef/provider/chef_provider.dart';
import 'package:oyt_admin/features/chef/ui/dialogs/add_chef_dialog.dart';
import 'package:oyt_front_widgets/error/not_found_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class ChefTab extends ConsumerStatefulWidget {
  const ChefTab({super.key});

  @override
  ConsumerState<ChefTab> createState() => _CashierTabState();
}

class _CashierTabState extends ConsumerState<ChefTab> {
  final _scrollController = ScrollController();
  final _textEditingController = TextEditingController();
  String filter = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChef(String query) {
    filter = query;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final chefState = ref.watch(chefProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Chef',
          subtitle:
              'Acá puedes ver los chef del restaurante, editar los chef, eliminar chef y agregar nuevos chefs.',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Buscar chef',
                onChanged: _onSearchChef,
                prefixIcon: const Icon(Icons.search),
                controller: _textEditingController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            AddButton(onTap: _onAddChef, text: 'Agregar chef'),
          ],
        ),
        const Divider(),
        Expanded(
          child: chefState.chefs.on(
            onError: (error) => Center(child: Text(error.toString())),
            onLoading: () => const ScreenLoadingWidget(),
            onInitial: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(chefProvider.notifier).getChefs();
              });
              return const ScreenLoadingWidget();
            },
            onData: (chefs) {
              final filteredChefs = chefs.where((chef) => chef.filter(filter)).toList();
              if (filteredChefs.isEmpty) {
                return const NotFoundWidget(title: 'No se encontraron chefs');
              }
              return Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredChefs.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      onTap: () => _onTapChef(),
                      subtitle: Text('Correo: ${filteredChefs[i].email}'),
                      title:
                          Text('Chef ${filteredChefs[i].firstName} ${filteredChefs[i].lastName}'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onAddChef() => AddChefDialog.show(context: context);

  void _onTapChef() {}
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/cashier/models/cashier_model.dart';
import 'package:oyt_admin/features/cashier/provider/cashier_provider.dart';
import 'package:oyt_admin/features/cashier/ui/dialogs/add_cashier_dialog.dart';
import 'package:oyt_admin/features/cashier/ui/dialogs/cashier_detail_dialog.dart';
import 'package:oyt_front_widgets/error/not_found_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_front_widgets/buttons/add_button.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class CashierTab extends ConsumerStatefulWidget {
  const CashierTab({super.key});

  @override
  ConsumerState<CashierTab> createState() => _CashierTabState();
}

class _CashierTabState extends ConsumerState<CashierTab> {
  final _scrollController = ScrollController();
  final _textEditingController = TextEditingController();
  String filter = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchWaiter(String query) {
    filter = query.toLowerCase();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cashierState = ref.watch(cashierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Cajeros',
          subtitle:
              'Acá puedes ver los cajeros del restaurante, editar los cajeros, eliminar cajeros y agregar nuevos cajeros.',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Buscar cajero',
                onChanged: _onSearchWaiter,
                prefixIcon: const Icon(Icons.search),
                controller: _textEditingController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            AddButton(onTap: _onAddCashier, text: 'Agregar cajero'),
          ],
        ),
        const Divider(),
        Expanded(
          child: cashierState.cashiers.on(
            onError: (error) => Center(child: Text(error.toString())),
            onLoading: () => const ScreenLoadingWidget(),
            onInitial: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(cashierProvider.notifier).getCashiers();
              });
              return const ScreenLoadingWidget();
            },
            onData: (cashiers) {
              final filteredCashiers = cashiers.where((cashier) => cashier.filter(filter)).toList();
              if (filteredCashiers.isEmpty) {
                return const NotFoundWidget(title: 'No se encontraron cajeros');
              }
              return Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredCashiers.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: filteredCashiers[i].isAvailable
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      minLeadingWidth: 35,
                      onTap: () => _onTapWaiter(filteredCashiers[i]),
                      subtitle: Text('Correo: ${filteredCashiers[i].email}'),
                      title: Text('${filteredCashiers[i].firstName} ${filteredCashiers[i].lastName}'),
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

  void _onAddCashier() => AddCashierDialog.show(context: context);

  void _onTapWaiter(Cashier cashier) =>
      CashierDetailDialog.show(context: context, cashier: cashier);
}

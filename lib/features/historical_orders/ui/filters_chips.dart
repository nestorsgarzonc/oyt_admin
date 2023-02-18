import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/historical_orders/filter/historical_order_filter.dart';

class FilterChips extends ConsumerStatefulWidget {

  FilterChips({super.key, this.historicalOrdersFilter});
  
  HistoricalOrdersFilter? historicalOrdersFilter;

  @override
  ConsumerState<FilterChips> createState() => _FilterChips();
}

class _FilterChips extends ConsumerState<FilterChips> {

  @override
  Widget build (BuildContext context) {
    if (widget.historicalOrdersFilter != null) {
      return Wrap(
        children: [
          Chip(
            label: Text('Desde ${widget.historicalOrdersFilter!.dateStart?.day}/${widget.historicalOrdersFilter!.dateStart?.month}/${widget.historicalOrdersFilter!.dateStart?.year}'),
            deleteIcon: const Icon(Icons.close_rounded),
            onDeleted: () {
              widget.historicalOrdersFilter!.dateStart = null;
            },
          ),
          Chip(
            label: Text('Hasta ${widget.historicalOrdersFilter!.dateEnd?.day}/${widget.historicalOrdersFilter!.dateEnd?.month}/${widget.historicalOrdersFilter!.dateEnd?.year}'),
            deleteIcon: const Icon(Icons.close_rounded),
            onDeleted: () {
              widget.historicalOrdersFilter!.dateEnd = null;
            },
          ),
          Chip(
            label: Text('Precio de \$${widget.historicalOrdersFilter!.orderPrice}'),
            deleteIcon: const Icon(Icons.close_rounded),
            onDeleted: () {
              widget.historicalOrdersFilter!.orderPrice = null;
            },
          ),
          Chip(
            label: Text('Pagado mediante ${widget.historicalOrdersFilter!.paymentMethod}'),
            deleteIcon: const Icon(Icons.close_rounded),
            onDeleted: () {
              widget.historicalOrdersFilter!.paymentMethod = null;
            },
          )
        ],
      );
    }
    return const SizedBox();
  }
}
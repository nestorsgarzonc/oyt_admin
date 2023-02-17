import 'package:equatable/equatable.dart';
import 'package:oyt_admin/features/cashier/models/cashier_model.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';

class CashierState extends Equatable {
  const CashierState(this.cashiers);

  factory CashierState.initial() {
    return CashierState(StateAsync<List<Cashier>>.initial());
  }

  final StateAsync<List<Cashier>> cashiers;

  CashierState copyWith({StateAsync<List<Cashier>>? cashiers}) {
    return CashierState(cashiers ?? this.cashiers);
  }

  @override
  List<Object> get props => [cashiers];
}

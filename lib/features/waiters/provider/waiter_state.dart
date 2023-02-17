import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_admin/features/waiters/models/waiter_model.dart';

class WaiterState extends Equatable {
  const WaiterState(this.waiters);

  factory WaiterState.initial() {
    return WaiterState(StateAsync<List<Waiter>>.initial());
  }

  final StateAsync<List<Waiter>> waiters;

  WaiterState copyWith({StateAsync<List<Waiter>>? waiters}) {
    return WaiterState(waiters ?? this.waiters);
  }

  @override
  List<Object> get props => [waiters];
}

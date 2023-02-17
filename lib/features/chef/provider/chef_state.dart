import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_admin/features/chef/models/chef_model.dart';

class ChefState extends Equatable {
  const ChefState(this.chefs);

  factory ChefState.initial() {
    return ChefState(StateAsync<List<Chef>>.initial());
  }

  final StateAsync<List<Chef>> chefs;

  ChefState copyWith({StateAsync<List<Chef>>? chefs}) {
    return ChefState(chefs ?? this.chefs);
  }

  @override
  List<Object> get props => [chefs];
}

import 'package:equatable/equatable.dart';
import 'package:oyt_admin/features/auth/models/check_admin_response.dart';
import 'package:oyt_front_auth/models/auth_model.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.authModel,
    required this.checkWaiterResponse,
  });

  factory AuthState.initial() {
    return AuthState(
      authModel: StateAsync.initial(),
      checkWaiterResponse: StateAsync.initial(),
    );
  }

  final StateAsync<AuthModel> authModel;
  final StateAsync<CheckAdminResponse> checkWaiterResponse;

  AuthState copyWith({
    StateAsync<AuthModel>? authModel,
    StateAsync<CheckAdminResponse>? checkWaiterResponse,
  }) {
    return AuthState(
      authModel: authModel ?? this.authModel,
      checkWaiterResponse: checkWaiterResponse ?? this.checkWaiterResponse,
    );
  }

  @override
  List<Object?> get props => [authModel];
}

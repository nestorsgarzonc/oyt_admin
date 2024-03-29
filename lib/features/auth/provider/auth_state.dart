import 'package:equatable/equatable.dart';
import 'package:oyt_front_auth/models/auth_model.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_admin/features/auth/models/check_admin_response.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.authModel,
    required this.checkAdminResponse,
    required this.selectedRestaurantId,
  });

  factory AuthState.initial() {
    return AuthState(
      authModel: StateAsync.initial(),
      checkAdminResponse: StateAsync.initial(),
      selectedRestaurantId: StateAsync.initial(),
    );
  }

  final StateAsync<AuthModel> authModel;
  final StateAsync<CheckAdminResponse> checkAdminResponse;
  final StateAsync<String> selectedRestaurantId;

  String get restaurantId => selectedRestaurantId.data ?? '';

  AuthState copyWith({
    StateAsync<AuthModel>? authModel,
    StateAsync<CheckAdminResponse>? checkAdminResponse,
    StateAsync<String>? selectedRestaurantId,
  }) {
    return AuthState(
      authModel: authModel ?? this.authModel,
      checkAdminResponse: checkAdminResponse ?? this.checkAdminResponse,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
    );
  }

  @override
  List<Object> get props => [authModel, checkAdminResponse, selectedRestaurantId];
}

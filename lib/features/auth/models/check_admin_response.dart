// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CheckAdminResponse extends Equatable {
  const CheckAdminResponse({
    required this.restaurantsId,
  });

  final List<String> restaurantsId;

  @override
  List<Object> get props => [restaurantsId];

  CheckAdminResponse copyWith({
    List<String>? restaurantsId,
  }) {
    return CheckAdminResponse(restaurantsId: restaurantsId ?? this.restaurantsId);
  }

  factory CheckAdminResponse.fromMap(Map<String, dynamic> map) {
    return CheckAdminResponse(restaurantsId: List<String>.from((map['restaurants'])));
  }

  factory CheckAdminResponse.fromJson(String source) =>
      CheckAdminResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}

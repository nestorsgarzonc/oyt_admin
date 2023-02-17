import 'package:equatable/equatable.dart';

class WaiterDto extends Equatable {
  const WaiterDto({required this.email});

  factory WaiterDto.fromMap(Map<String, dynamic> map) {
    return WaiterDto(
      email: map['waiterEmail'] as String,
    );
  }

  final String email;

  @override
  List<Object> get props => [email];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'waiterEmail': email};
  }

  WaiterDto copyWith({String? email}) {
    return WaiterDto(email: email ?? this.email);
  }
}

import 'package:equatable/equatable.dart';

class CashierDto extends Equatable {
  const CashierDto({required this.email});

  factory CashierDto.fromMap(Map<String, dynamic> map) {
    return CashierDto(
      email: map['cashierEmail'] as String,
    );
  }

  final String email;

  @override
  List<Object> get props => [email];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'cashierEmail': email};
  }

  CashierDto copyWith({String? email}) {
    return CashierDto(email: email ?? this.email);
  }
}

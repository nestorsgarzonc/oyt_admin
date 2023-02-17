import 'package:equatable/equatable.dart';

class ChefDto extends Equatable {
  const ChefDto({required this.email});

  factory ChefDto.fromMap(Map<String, dynamic> map) {
    return ChefDto(
      email: map['chefEmail'] as String,
    );
  }

  final String email;

  @override
  List<Object> get props => [email];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'chefEmail': email};
  }

  ChefDto copyWith({String? email}) {
    return ChefDto(email: email ?? this.email);
  }
}

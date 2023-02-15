import 'package:equatable/equatable.dart';

class HistoricalOrdersFilter extends Equatable {
 HistoricalOrdersFilter();

  DateTime? dateStart;
  DateTime? dateEnd;
  num? orderPrice;
  String? paymentMethod;
  
  Map<String, dynamic> toMap() {
    return {
      'fechaInicio': dateStart,
      'fechaFin':dateEnd,
      'valorOrden':orderPrice,
      'paymentMethod':paymentMethod,
    };
  }

  @override
  List<Object?> get props => [dateStart, dateEnd, orderPrice, paymentMethod];
}
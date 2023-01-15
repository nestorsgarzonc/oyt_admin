import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_product/models/product_model.dart';

class ProductState extends Equatable {
  const ProductState({
    required this.productDetail,
  });

  final StateAsync<ProductDetailModel> productDetail;

  ProductState copyWith({StateAsync<ProductDetailModel>? productDetail}) {
    return ProductState(
      productDetail: productDetail ?? this.productDetail,
    );
  }

  @override
  List<Object?> get props => [productDetail];
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_admin/features/product/provider/product_state.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_product/repositories/product_repositories.dart';

final productProvider = StateNotifierProvider<ProductProvider, ProductState>((ref) {
  return ProductProvider.fromRead(ref);
});

class ProductProvider extends StateNotifier<ProductState> {
  ProductProvider({
    required this.productRepository,
    required this.ref,
    required this.socketIOHandler,
  }) : super(ProductState(productDetail: StateAsync.initial()));

  factory ProductProvider.fromRead(Ref ref) {
    final productRepository = ref.read(productRepositoryProvider);
    final socketIo = ref.read(socketProvider);
    return ProductProvider(
      ref: ref,
      productRepository: productRepository,
      socketIOHandler: socketIo,
    );
  }

  final Ref ref;
  final ProductRepository productRepository;
  final SocketIOHandler socketIOHandler;

  Future<void> productDetail(String productID) async {
    state = state.copyWith(productDetail: StateAsync.loading());
    final res = await productRepository.productDetail(productID);
    res.fold(
      (l) {
        state = state.copyWith(productDetail: StateAsync.error(l));
      },
      (r) {
        state = state.copyWith(productDetail: StateAsync.success(r));
      },
    );
  }

  Future<void> cleanProductDetail(String productID) async {
    state = state.copyWith(productDetail: StateAsync.initial());
  }
}

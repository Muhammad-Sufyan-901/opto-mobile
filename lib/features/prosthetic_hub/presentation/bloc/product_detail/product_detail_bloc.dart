// BLoC for product detail operations — sits between [CatalogRepository] and the
// product detail screen.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/catalog_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/product_detail/product_detail_event.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/product_detail/product_detail_state.dart';

export 'product_detail_event.dart';
export 'product_detail_state.dart';

/// BLoC that drives the product detail screen.
///
/// Inject by the abstract [CatalogRepository] contract — never by the impl.
class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final CatalogRepository _repo;

  ProductDetailBloc(this._repo) : super(const ProductDetailState.initial()) {
    on<ProductDetailLoad>(_onLoad);
  }

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _onLoad(
    ProductDetailLoad event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailState.loading());
    try {
      final product = await _repo.getProductById(event.productId);

      // Vendor fetch must follow product because vendorId is unknown until
      // the product loads.
      final vendor = product.vendorId != null
          ? await _repo.getVendor(product.vendorId!)
          : null;

      emit(ProductDetailState.loaded(product: product, vendor: vendor));
    } on Failure catch (f) {
      emit(ProductDetailState.error(_toMessage(f)));
    } catch (e) {
      emit(const ProductDetailState.error('An unexpected error occurred.'));
    }
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  String _toMessage(Failure f) {
    if (f is ServerFailure) {
      if (f.message.contains('not found') ||
          f.message.contains('Tidak ditemukan')) {
        return 'Product not found.';
      }
      if (f.message.contains('permission') ||
          f.message.contains('izin')) {
        return 'You do not have permission to view this product.';
      }
      return f.message;
    }
    if (f is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (f is AuthFailure) {
      return 'Please sign in to view this product.';
    }
    return f.message;
  }
}

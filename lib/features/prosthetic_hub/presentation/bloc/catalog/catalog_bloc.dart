// BLoC for catalog operations — sits between [CatalogRepository] and the
// catalog screens.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/catalog_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/catalog/catalog_event.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/catalog/catalog_state.dart';

export 'catalog_event.dart';
export 'catalog_state.dart';

/// BLoC that drives the catalog listing and product detail screens.
///
/// Inject by the abstract [CatalogRepository] contract — never by the impl.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _repo;

  CatalogBloc(this._repo) : super(const CatalogState.initial()) {
    on<LoadCatalog>(_onLoadCatalog);
    on<LoadProduct>(_onLoadProduct);
  }

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _onLoadCatalog(
    LoadCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogState.loading());
    try {
      final products = await _repo.getProducts(
        typeFilter: event.typeFilter,
        irisColorFilter: event.irisColorFilter,
        sizeFilter: event.sizeFilter,
      );
      emit(CatalogState.loaded(products));
    } on Failure catch (f) {
      emit(CatalogState.error(_toMessage(f)));
    } catch (e) {
      emit(const CatalogState.error('An unexpected error occurred.'));
    }
  }

  Future<void> _onLoadProduct(
    LoadProduct event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogState.loading());
    try {
      final product = await _repo.getProductById(event.productId);

      // Fetch product first; vendor fetch must follow because vendorId is unknown until product loads.
      final vendorFuture = product.vendorId != null
          ? _repo.getVendor(product.vendorId!)
          : Future.value(null);

      final vendor = await vendorFuture;
      emit(CatalogState.productLoaded(product: product, vendor: vendor));
    } on Failure catch (f) {
      emit(CatalogState.error(_toMessage(f)));
    } catch (e) {
      emit(const CatalogState.error('An unexpected error occurred.'));
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
        return 'You do not have permission to view this catalog.';
      }
      return f.message;
    }
    if (f is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (f is AuthFailure) {
      return 'Please sign in to view the catalog.';
    }
    return f.message;
  }
}

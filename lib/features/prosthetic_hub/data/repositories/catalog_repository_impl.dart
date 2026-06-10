// Repository implementation for the catalog domain area.
//
// Delegates all I/O to [ProstheticRemoteDataSource]; maps data-layer models to
// domain entities via the `_ext.dart` extensions.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/data/datasources/prosthetic_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/data/models/prosthetic_product_model_ext.dart';
import 'package:opto/features/prosthetic_hub/data/models/vendor_model_ext.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/vendor_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/catalog_repository.dart';

/// Production [CatalogRepository] backed by [ProstheticRemoteDataSource].
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl({required ProstheticRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final ProstheticRemoteDataSource _remote;

  @override
  Future<List<ProstheticProductEntity>> getProducts({
    ProductType? typeFilter,
    String? irisColorFilter,
    String? sizeFilter,
  }) async {
    final models = await _remote.getProducts(
      typeFilter: typeFilter,
      irisColorFilter: irisColorFilter,
      sizeFilter: sizeFilter,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ProstheticProductEntity> getProductById(String id) async {
    final model = await _remote.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<VendorEntity?> getVendor(String vendorId) async {
    final model = await _remote.getVendor(vendorId);
    return model?.toEntity();
  }
}

// Repository implementation for the Order Supplies feature.
//
// Delegates all I/O to [SuppliesRemoteDataSource] — this class is responsible
// only for wiring the datasource to the domain contract.
// No Supabase / network imports belong here.

import 'package:opto/features/prosthetic_hub/data/datasources/supplies_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/supplies_repository.dart';

/// Production [SuppliesRepository] backed by Supabase via
/// [SuppliesRemoteDataSource].
class SuppliesRepositoryImpl implements SuppliesRepository {
  const SuppliesRepositoryImpl({
    required SuppliesRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final SuppliesRemoteDataSource _remote;

  @override
  Future<List<SupplyProduct>> getProducts() => _remote.getProducts();

  @override
  Future<void> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required bool consentGiven,
  }) =>
      _remote.placeOrder(
        cart: cart,
        products: products,
        consentGiven: consentGiven,
      );
}

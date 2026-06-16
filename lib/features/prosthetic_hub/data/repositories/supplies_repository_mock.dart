// Mock implementation of [SuppliesRepository].
//
// Returns hardcoded data synchronously — no network or Supabase dependency.
// Replace with a real Supabase-backed implementation once the backend table
// is provisioned (see `system_architecture.md` Appendix A).

import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/supplies_repository.dart';

/// Hardcoded supply product data for UI development and testing.
class SuppliesRepositoryMock implements SuppliesRepository {
  const SuppliesRepositoryMock();

  @override
  Future<List<SupplyProduct>> getProducts() async {
    return const [
      // 1 — Daily Cleaning Solution
      SupplyProduct(
        id: 'p1',
        name: 'Daily Cleaning Solution',
        type: SupplyProductType.solution,
        audioDescription:
            'Saline-based daily cleaning solution for ocular prostheses. 100ml bottle. Alcohol-free.',
        priceIdr: 45000,
        isCustom: false,
      ),

      // 2 — Premium Self-Cleaning Case
      SupplyProduct(
        id: 'p2',
        name: 'Premium Self-Cleaning Case',
        type: SupplyProductType.selfCleaningCase,
        audioDescription:
            'Ultrasonic self-cleaning case for overnight care. USB-rechargeable. Includes solution refill.',
        priceIdr: 350000,
        isCustom: false,
      ),

      // 3 — Standard Storage Case
      SupplyProduct(
        id: 'p3',
        name: 'Standard Storage Case',
        type: SupplyProductType.storageCase,
        audioDescription:
            'Hard-shell storage case with padded interior. Fits all standard ocular prostheses.',
        priceIdr: 85000,
        isCustom: false,
      ),

      // 4 — Prosthetic Care Kit
      SupplyProduct(
        id: 'p4',
        name: 'Prosthetic Care Kit',
        type: SupplyProductType.careKit,
        audioDescription:
            'Complete starter kit: cleaning solution, storage case, and microfiber cloth. Recommended for new users.',
        priceIdr: 195000,
        isCustom: false,
      ),

      // 5 — Microfiber Cleaning Cloth
      SupplyProduct(
        id: 'p5',
        name: 'Microfiber Cleaning Cloth',
        type: SupplyProductType.cloth,
        audioDescription:
            'Ultra-soft microfiber cloth, lint-free. Pack of 5. Safe for lens surfaces.',
        priceIdr: 25000,
        isCustom: false,
      ),
    ];
  }

  @override
  Future<void> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required bool consentGiven,
  }) async {
    // Mock: no-op for testing
  }
}

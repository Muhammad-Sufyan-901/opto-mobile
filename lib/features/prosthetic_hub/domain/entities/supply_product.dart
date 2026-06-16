// Domain entity for a prosthetic supply product.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

/// Categories of supply product available in the Opto Prosthetic Hub shop.
enum SupplyProductType {
  selfCleaningCase,
  careKit,
  solution,
  cloth,
  storageCase,
}

/// Human-readable display label for each [SupplyProductType].
extension SupplyProductTypeLabel on SupplyProductType {
  String get displayLabel => switch (this) {
        SupplyProductType.selfCleaningCase => 'Self-Cleaning Case',
        SupplyProductType.careKit => 'Care Kit',
        SupplyProductType.solution => 'Solution',
        SupplyProductType.cloth => 'Cloth',
        SupplyProductType.storageCase => 'Storage Case',
      };

  String get imageAssetPath => switch (this) {
        SupplyProductType.solution =>
          'assets/images/supplies/daily_cleaning_solution.png',
        SupplyProductType.selfCleaningCase =>
          'assets/images/supplies/self_cleaning_case.png',
        SupplyProductType.storageCase =>
          'assets/images/supplies/standard_storage_case.png',
        SupplyProductType.careKit =>
          'assets/images/supplies/prosthetic_care_kit.png',
        SupplyProductType.cloth =>
          'assets/images/supplies/microfiber_cleaning_cloth.png',
      };
}

/// Maps a Postgres `product_type` enum string to a [SupplyProductType].
///
/// Throws [ArgumentError] for unknown values so data-layer bugs surface early.
SupplyProductType supplyProductTypeFromDb(String dbValue) => switch (dbValue) {
      'self_cleaning_case' => SupplyProductType.selfCleaningCase,
      'care_kit' => SupplyProductType.careKit,
      'solution' => SupplyProductType.solution,
      'cloth' => SupplyProductType.cloth,
      'storage_case' => SupplyProductType.storageCase,
      _ => throw ArgumentError('Unknown product_type: $dbValue'),
    };

/// Immutable domain representation of a prosthetic supply product.
///
/// [audioDescription] is the spoken description read aloud by Aura Voice /
/// screen readers when the user navigates to this product.
class SupplyProduct {
  const SupplyProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.audioDescription,
    required this.priceIdr,
    required this.isCustom,
    this.imageUrl,
  });

  /// Primary key (string UUID or slug).
  final String id;

  /// Display name shown on the product card.
  final String name;

  /// Which product category this item belongs to.
  final SupplyProductType type;

  /// Spoken description for Aura Voice / screen readers.
  final String audioDescription;

  /// Price in Indonesian Rupiah (IDR).
  final int priceIdr;

  /// Whether this product requires custom fabrication.
  final bool isCustom;

  /// Remote image URL from Supabase Storage (null for mock / local-asset products).
  final String? imageUrl;

  // ---------------------------------------------------------------------------
  // copyWith — null-coalescent; passing null for any field keeps the existing
  // value. To explicitly clear imageUrl, create a new SupplyProduct instance.
  // ---------------------------------------------------------------------------

  SupplyProduct copyWith({
    String? id,
    String? name,
    SupplyProductType? type,
    String? audioDescription,
    int? priceIdr,
    bool? isCustom,
    String? imageUrl,
  }) {
    return SupplyProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      audioDescription: audioDescription ?? this.audioDescription,
      priceIdr: priceIdr ?? this.priceIdr,
      isCustom: isCustom ?? this.isCustom,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyProduct &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          audioDescription == other.audioDescription &&
          priceIdr == other.priceIdr &&
          isCustom == other.isCustom &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        type,
        audioDescription,
        priceIdr,
        isCustom,
        imageUrl,
      );
}

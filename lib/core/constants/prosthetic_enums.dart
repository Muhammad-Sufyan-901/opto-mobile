// Prosthetic Hub enums that mirror Postgres enum types in the Opto schema.
//
// These cover the catalog, tutorial, measurement, photo, and order tables
// used by the Prosthetic Hub module.
//
// NOTE: Identity-related enums ([VisionProfile], [LinkStatus], [HapticLevel])
//       live in `lib/core/constants/identity_enums.dart`.
// =============================================================================
// PRODUCT TYPE
// =============================================================================

/// The category of a product in the Prosthetic Hub catalog.
///
/// Mirrors the `product_type` Postgres enum in the `prosthetic_products` table.
enum ProductType {
  /// An ocular prosthesis (artificial eye).
  prosthesis,

  /// A self-cleaning storage/care case for the prosthesis.
  selfCleaningCase,

  /// A care kit containing cleaning and maintenance accessories.
  careKit;

  /// Parses a raw Postgres / JSON string to a [ProductType].
  /// Falls back to [prosthesis] for any unknown value.
  static ProductType fromString(String? value) {
    switch (value) {
      case 'prosthesis':
        return ProductType.prosthesis;
      case 'self_cleaning_case':
        return ProductType.selfCleaningCase;
      case 'care_kit':
        return ProductType.careKit;
      default:
        assert(false, 'Unknown ProductType db value: "$value"');
        return ProductType.prosthesis;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue => switch (this) {
        ProductType.prosthesis => 'prosthesis',
        ProductType.selfCleaningCase => 'self_cleaning_case',
        ProductType.careKit => 'care_kit',
      };
}

// =============================================================================
// TUTORIAL CATEGORY
// =============================================================================

/// The care-task category of a video tutorial.
///
/// Mirrors the `tutorial_category` Postgres enum in the `care_tutorials` table.
enum TutorialCategory {
  /// How to insert the prosthetic eye.
  insert,

  /// How to remove the prosthetic eye.
  remove,

  /// How to clean the prosthetic eye.
  clean,

  /// How to lubricate the prosthetic eye.
  lubricate,

  /// How to use the self-cleaning case.
  caseUse;

  /// Parses a raw Postgres / JSON string to a [TutorialCategory].
  /// Falls back to [clean] for any unknown value.
  static TutorialCategory fromString(String? value) {
    switch (value) {
      case 'insert':
        return TutorialCategory.insert;
      case 'remove':
        return TutorialCategory.remove;
      case 'clean':
        return TutorialCategory.clean;
      case 'lubricate':
        return TutorialCategory.lubricate;
      case 'case_use':
        return TutorialCategory.caseUse;
      default:
        assert(false, 'Unknown TutorialCategory db value: "$value"');
        return TutorialCategory.clean;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue => switch (this) {
        TutorialCategory.insert => 'insert',
        TutorialCategory.remove => 'remove',
        TutorialCategory.clean => 'clean',
        TutorialCategory.lubricate => 'lubricate',
        TutorialCategory.caseUse => 'case_use',
      };
}

// =============================================================================
// DATA SOURCE
// =============================================================================

/// Indicates the origin of an anthropometric measurement record.
///
/// Mirrors the `data_source` Postgres enum in the `anthropometric_data` table.
enum DataSource {
  /// Measurement was taken by the user themselves.
  selfMeasured,

  /// Measurement was recorded by a licensed ocularist.
  ocularistRecord;

  /// Parses a raw Postgres / JSON string to a [DataSource].
  /// Falls back to [selfMeasured] for any unknown value.
  static DataSource fromString(String? value) {
    switch (value) {
      case 'self_measured':
        return DataSource.selfMeasured;
      case 'ocularist_record':
        return DataSource.ocularistRecord;
      default:
        assert(false, 'Unknown DataSource db value: "$value"');
        return DataSource.selfMeasured;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue => switch (this) {
        DataSource.selfMeasured => 'self_measured',
        DataSource.ocularistRecord => 'ocularist_record',
      };
}

// =============================================================================
// PHOTO PURPOSE
// =============================================================================

/// The intended use of an eye photo stored in Supabase Storage.
///
/// Mirrors the `photo_purpose` Postgres enum in the `eye_photos` table.
/// ⚠️ This table is medically sensitive (🔒) — see `database_schema.md`.
enum PhotoPurpose {
  /// Photo taken to match iris colour/pattern for the prosthesis order.
  irisMatch,

  /// Photo shared with the consulting ocularist or doctor.
  consultation,

  /// Photo tracking the socket's visual progression over time.
  progress;

  /// Parses a raw Postgres / JSON string to a [PhotoPurpose].
  /// Falls back to [irisMatch] for any unknown value.
  static PhotoPurpose fromString(String? value) {
    switch (value) {
      case 'iris_match':
        return PhotoPurpose.irisMatch;
      case 'consultation':
        return PhotoPurpose.consultation;
      case 'progress':
        return PhotoPurpose.progress;
      default:
        assert(false, 'Unknown PhotoPurpose db value: "$value"');
        return PhotoPurpose.irisMatch;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue => switch (this) {
        PhotoPurpose.irisMatch => 'iris_match',
        PhotoPurpose.consultation => 'consultation',
        PhotoPurpose.progress => 'progress',
      };
}

// =============================================================================
// ORDER STATUS
// =============================================================================

/// Lifecycle state of a prosthetic order.
///
/// Mirrors the `order_status` Postgres enum in the `prosthetic_orders` table.
enum OrderStatus {
  /// Order saved locally but not yet submitted.
  draft,

  /// Order submitted and awaiting review.
  submitted,

  /// Order is being reviewed by the ocularist team.
  inReview,

  /// Order has been approved and is in production.
  inProduction,

  /// Order has been shipped and is in transit.
  shipped,

  /// Order has been received and completed.
  completed,

  /// Order was cancelled before completion.
  cancelled;

  /// Parses a raw Postgres / JSON string to an [OrderStatus].
  /// Falls back to [draft] for any unknown value.
  static OrderStatus fromString(String? value) {
    switch (value) {
      case 'draft':
        return OrderStatus.draft;
      case 'submitted':
        return OrderStatus.submitted;
      case 'in_review':
        return OrderStatus.inReview;
      case 'in_production':
        return OrderStatus.inProduction;
      case 'shipped':
        return OrderStatus.shipped;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        assert(false, 'Unknown OrderStatus db value: "$value"');
        return OrderStatus.draft;
    }
  }

  /// Canonical snake_case string written to Postgres.
  String get dbValue => switch (this) {
        OrderStatus.draft => 'draft',
        OrderStatus.submitted => 'submitted',
        OrderStatus.inReview => 'in_review',
        OrderStatus.inProduction => 'in_production',
        OrderStatus.shipped => 'shipped',
        OrderStatus.completed => 'completed',
        OrderStatus.cancelled => 'cancelled',
      };
}

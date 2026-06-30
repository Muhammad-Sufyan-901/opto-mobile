// Domain entity for the user's clinical vision/eye details (🔒 owner-only).
//
// Mirrors the `vision_clinical_profile` Supabase table.
// This is medically sensitive data — never pass to community or map surfaces.

/// A single assistive technology device the user uses.
class AssistiveTech {
  const AssistiveTech({required this.name, required this.enabled});

  final String name;
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistiveTech && name == other.name && enabled == other.enabled;

  @override
  int get hashCode => Object.hash(name, enabled);
}

/// Immutable domain entity for the `vision_clinical_profile` table.
class VisionClinicalEntity {
  const VisionClinicalEntity({
    required this.userId,
    this.diagnosis,
    this.diagnosisSeverity,
    this.affectedEyes,
    this.diagnosedYear,
    this.lightPerception,
    this.centralAcuity,
    this.visualField,
    this.prosthesisEye,
    this.prosthesisType,
    this.prosthesisMaterial,
    this.prosthesisFittedDate,
    this.prosthesisFittedClinic,
    this.lastPolishDate,
    this.nextPolishDue,
    this.assistiveTech = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Foreign key to `profiles.id` (UUID) — also the PK of this table.
  final String userId;

  /// Primary eye diagnosis (e.g. 'retinoblastoma', 'glaucoma').
  final String? diagnosis;

  /// Severity classification (e.g. 'mild', 'moderate', 'severe', 'profound').
  final String? diagnosisSeverity;

  /// Which eye(s) are affected (e.g. 'left', 'right', 'both').
  final String? affectedEyes;

  /// Year the diagnosis was confirmed (e.g. 2018).
  final int? diagnosedYear;

  /// Whether the user can perceive light (e.g. 'yes', 'no', 'unknown').
  final String? lightPerception;

  /// Best corrected visual acuity string (e.g. '20/200', 'NLP').
  final String? centralAcuity;

  /// Visual field description or degrees (e.g. '10 degrees central').
  final String? visualField;

  /// Which eye has the prosthesis ('left', 'right', 'both', or null).
  final String? prosthesisEye;

  /// Type of ocular prosthesis (e.g. 'stock', 'custom').
  final String? prosthesisType;

  /// Material of the prosthesis (e.g. 'acrylic', 'glass').
  final String? prosthesisMaterial;

  /// Date the prosthesis was fitted.
  final DateTime? prosthesisFittedDate;

  /// Name or location of the clinic where the prosthesis was fitted.
  final String? prosthesisFittedClinic;

  /// Date of the last prosthesis polish appointment.
  final DateTime? lastPolishDate;

  /// Scheduled date for the next prosthesis polish.
  final DateTime? nextPolishDue;

  /// List of assistive technology devices the user relies on.
  final List<AssistiveTech> assistiveTech;

  /// Row creation timestamp (set by Postgres default).
  final DateTime? createdAt;

  /// Row last-updated timestamp (managed by DB trigger).
  final DateTime? updatedAt;

  /// Creates a copy with the given fields replaced.
  ///
  /// Note: passing `null` for a nullable field leaves it unchanged (does not
  /// clear it). To explicitly clear a nullable field, create a new instance
  /// with `VisionClinicalEntity(...)`.
  VisionClinicalEntity copyWith({
    String? userId,
    String? diagnosis,
    String? diagnosisSeverity,
    String? affectedEyes,
    int? diagnosedYear,
    String? lightPerception,
    String? centralAcuity,
    String? visualField,
    String? prosthesisEye,
    String? prosthesisType,
    String? prosthesisMaterial,
    DateTime? prosthesisFittedDate,
    String? prosthesisFittedClinic,
    DateTime? lastPolishDate,
    DateTime? nextPolishDue,
    List<AssistiveTech>? assistiveTech,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VisionClinicalEntity(
      userId: userId ?? this.userId,
      diagnosis: diagnosis ?? this.diagnosis,
      diagnosisSeverity: diagnosisSeverity ?? this.diagnosisSeverity,
      affectedEyes: affectedEyes ?? this.affectedEyes,
      diagnosedYear: diagnosedYear ?? this.diagnosedYear,
      lightPerception: lightPerception ?? this.lightPerception,
      centralAcuity: centralAcuity ?? this.centralAcuity,
      visualField: visualField ?? this.visualField,
      prosthesisEye: prosthesisEye ?? this.prosthesisEye,
      prosthesisType: prosthesisType ?? this.prosthesisType,
      prosthesisMaterial: prosthesisMaterial ?? this.prosthesisMaterial,
      prosthesisFittedDate: prosthesisFittedDate ?? this.prosthesisFittedDate,
      prosthesisFittedClinic:
          prosthesisFittedClinic ?? this.prosthesisFittedClinic,
      lastPolishDate: lastPolishDate ?? this.lastPolishDate,
      nextPolishDue: nextPolishDue ?? this.nextPolishDue,
      assistiveTech: assistiveTech ?? this.assistiveTech,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Identity equality — two entities for the same user represent the same
  /// clinical record, regardless of field values.
  ///
  /// NOTE: BLoC `emit()` de-duplicates states using `==`. Because this entity
  /// uses identity-only equality, loading updated clinical data WILL always
  /// trigger a rebuild (different object instance ≠ equal, unless identical).
  /// This is intentional: the [VisionClinicalCubit] emits new instances on
  /// every load, so rebuilds are always triggered correctly.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisionClinicalEntity && userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

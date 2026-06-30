// Domain entity for an emergency contact.
//
// Pure-Dart representation used in use-cases and BLoC states.
// Mirrors [EmergencyContactModel] without serialisation dependencies.
//
// SECURITY NOTE: Owner-only data — never expose in community or map features.

// Sentinel used by copyWith to distinguish "pass null to clear" from "omitted".
const _absent = Object();

/// Immutable domain representation of the `emergency_contacts` table row.
class EmergencyContactEntity {
  const EmergencyContactEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.relationship,
    this.priority = 0,
  });

  /// Primary key (UUID).
  final String id;

  /// Foreign key to `profiles.id` — the owner of this contact.
  final String userId;

  /// Full name of the emergency contact.
  final String name;

  /// Phone number of the emergency contact.
  final String phone;

  /// Optional relationship label (e.g. "Mother", "Spouse").
  final String? relationship;

  /// Sort order; lower numbers are contacted first.
  final int priority;

  /// Creates a copy with the given fields replaced.
  ///
  /// Pass `null` explicitly for [relationship] to clear it:
  /// `contact.copyWith(relationship: null)`.
  EmergencyContactEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    Object? relationship = _absent,
    int? priority,
  }) {
    return EmergencyContactEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: identical(relationship, _absent)
          ? this.relationship
          : relationship as String?,
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContactEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          phone == other.phone &&
          relationship == other.relationship &&
          priority == other.priority;

  @override
  int get hashCode =>
      Object.hash(id, userId, name, phone, relationship, priority);
}

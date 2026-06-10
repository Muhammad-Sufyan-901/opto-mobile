// Domain entity for a caregiver link.
//
// Pure-Dart representation used in use-cases and BLoC states.
// Mirrors [CaregiverLinkModel] without serialisation dependencies.
//
// SECURITY NOTE: Owner-only data — never expose caregiver IDs in community
// or map surfaces.
import 'package:collection/collection.dart';
import 'package:opto/core/constants/identity_enums.dart';

/// Immutable domain representation of the `caregiver_links` table row.
class CaregiverLinkEntity {
  const CaregiverLinkEntity({
    required this.id,
    required this.userId,
    required this.caregiverId,
    this.status = LinkStatus.pending,
    this.permissions = const <String>[],
    required this.createdAt,
  });

  /// Primary key (UUID).
  final String id;

  /// Foreign key to `profiles.id` — the primary (low-vision) user.
  final String userId;

  /// Foreign key to `profiles.id` — the caregiver.
  final String caregiverId;

  /// Lifecycle state of the link.
  final LinkStatus status;

  /// Scoped permissions granted to the caregiver.
  final List<String> permissions;

  /// Row creation timestamp.
  final DateTime createdAt;

  /// Creates a copy with the given fields replaced.
  CaregiverLinkEntity copyWith({
    String? id,
    String? userId,
    String? caregiverId,
    LinkStatus? status,
    List<String>? permissions,
    DateTime? createdAt,
  }) {
    return CaregiverLinkEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caregiverId: caregiverId ?? this.caregiverId,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaregiverLinkEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          caregiverId == other.caregiverId &&
          status == other.status &&
          const ListEquality<String>().equals(permissions, other.permissions) &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      Object.hash(id, userId, caregiverId, status, const ListEquality<String>().hash(permissions), createdAt);
}

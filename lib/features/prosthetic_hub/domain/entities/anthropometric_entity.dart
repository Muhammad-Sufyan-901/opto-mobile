// Pure-Dart domain entity for anthropometric measurements.
//
// 🔒 SENSITIVE: owner-only data — never expose in community or catalog joins.
import 'package:opto/core/constants/prosthetic_enums.dart';

/// Immutable domain representation of a row in the `anthropometric_data` table.
class AnthropometricEntity {
  const AnthropometricEntity({
    required this.id,
    required this.userId,
    required this.source,
    this.socketSizeMm,
    this.curvature,
    this.irisDiameterMm,
    this.matchedIrisHex,
    this.createdAt,
  });

  /// Primary key (UUID).
  final String id;

  /// Owner user ID.
  final String userId;

  /// Socket size in millimetres (nullable).
  final double? socketSizeMm;

  /// Socket curvature in mm (nullable).
  final double? curvature;

  /// Iris diameter in millimetres (nullable).
  final double? irisDiameterMm;

  /// Hex colour string matched via colour CV (nullable).
  final String? matchedIrisHex;

  /// How the measurements were recorded.
  final DataSource source;

  /// Row creation timestamp.
  final String? createdAt;

  AnthropometricEntity copyWith({
    String? id,
    String? userId,
    double? socketSizeMm,
    double? curvature,
    double? irisDiameterMm,
    String? matchedIrisHex,
    DataSource? source,
    String? createdAt,
  }) =>
      AnthropometricEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        socketSizeMm: socketSizeMm ?? this.socketSizeMm,
        curvature: curvature ?? this.curvature,
        irisDiameterMm: irisDiameterMm ?? this.irisDiameterMm,
        matchedIrisHex: matchedIrisHex ?? this.matchedIrisHex,
        source: source ?? this.source,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnthropometricEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

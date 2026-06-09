// Domain contract for emergency contacts — `emergency_contacts` table.
//
// Implementations live in the data layer
// (`lib/features/profile/data/repositories/emergency_contact_repository_impl.dart`).
//
// SECURITY NOTE: `emergency_contacts` is owner-only (RLS).  This data must
// never appear in community, map, or catalog surfaces.
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/features/profile/domain/entities/emergency_contact_entity.dart';

/// Abstract contract for `emergency_contacts` table operations.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps
/// them to error states.
abstract class EmergencyContactRepository {
  /// Returns all emergency contacts for [userId] ordered by [priority]
  /// ascending (lowest number = highest priority = contacted first).
  ///
  /// Throws [ServerFailure] on network or RLS error.
  Future<List<EmergencyContactEntity>> getContacts(String userId);

  /// Inserts a new emergency contact row.
  ///
  /// The [contact] id field is ignored by the server (Postgres generates it).
  /// Throws [ServerFailure] on unique-constraint or RLS violation.
  Future<void> addContact(EmergencyContactEntity contact);

  /// Updates an existing emergency contact row identified by [contact.id].
  ///
  /// Throws [ServerFailure] if the row does not exist or on RLS violation.
  Future<void> updateContact(EmergencyContactEntity contact);

  /// Deletes the emergency contact row identified by [contactId].
  ///
  /// Throws [ServerFailure] if the row does not exist or on RLS violation.
  Future<void> deleteContact(String contactId);
}

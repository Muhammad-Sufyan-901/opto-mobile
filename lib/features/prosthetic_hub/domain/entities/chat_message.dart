// Domain entity representing a single message in a specialist chat room.
//
// Pure-Dart — no Supabase / serialization dependencies.
// Messages are stored in-memory in [SpecialistChatCubit].

/// An immutable chat message exchanged between the user and a specialist.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.specialistId,
    required this.text,
    required this.fromMe,
    required this.sentAt,
  });

  /// Unique message ID (UUID or timestamp-based string).
  final String id;

  /// ID of the specialist this message belongs to (used for room keying).
  final String specialistId;

  /// Message body text.
  final String text;

  /// True if the current user sent this message; false if the specialist sent it.
  final bool fromMe;

  /// When the message was sent (device local time for in-memory mock).
  final DateTime sentAt;

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          specialistId == other.specialistId &&
          text == other.text &&
          fromMe == other.fromMe &&
          sentAt == other.sentAt;

  @override
  int get hashCode => Object.hash(id, specialistId, text, fromMe, sentAt);
}

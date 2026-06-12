// Cubit for the per-specialist chat room.
//
// Stores messages in-memory, keyed by specialistId. No repository dependency —
// the mock simulates specialist replies via a 1500ms delayed Future.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/chat_message.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/specialist_chat_state.dart';

export 'specialist_chat_state.dart';

/// Cubit that drives the specialist chat room.
///
/// All messages are stored in-memory in [_rooms] (keyed by specialistId).
/// The state is never persisted — a fresh [SpecialistChatCubit] starts empty.
class SpecialistChatCubit extends Cubit<SpecialistChatState> {
  SpecialistChatCubit() : super(const SpecialistChatState.empty());

  /// In-memory message store: specialistId → ordered list of messages.
  final Map<String, List<ChatMessage>> _rooms = {};

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Opens the chat room for [specialistId] and emits its current messages.
  ///
  /// If the room has no messages yet, emits an empty list.
  void openRoom(String specialistId) {
    emit(SpecialistChatState.active(
      specialistId: specialistId,
      messages: List<ChatMessage>.from(_rooms[specialistId] ?? []),
    ));
  }

  /// Appends a user message to the active room and schedules a canned reply.
  ///
  /// No-op if the cubit is not in [SpecialistChatActive] state.
  void sendMessage(String text) {
    final currentState = state;
    if (currentState is! SpecialistChatActive) return;

    final specialistId = currentState.specialistId;
    final userMessage = ChatMessage(
      id: '${specialistId}_${DateTime.now().microsecondsSinceEpoch}_me',
      specialistId: specialistId,
      text: text,
      fromMe: true,
      sentAt: DateTime.now(),
    );

    final updatedMessages = [
      ...(_rooms[specialistId] ?? []),
      userMessage,
    ];
    _rooms[specialistId] = updatedMessages;

    if (!isClosed) {
      emit(SpecialistChatState.active(
        specialistId: specialistId,
        messages: List<ChatMessage>.from(updatedMessages),
      ));
    }

    // Schedule a canned auto-reply after 1500ms.
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (isClosed) return;
      if (state is! SpecialistChatActive) return;
      final activeState = state as SpecialistChatActive;
      if (activeState.specialistId != specialistId) return;

      const replyText =
          'Thank you for your message. I will review and respond to your inquiry shortly.';
      final replyMessage = ChatMessage(
        id: '${specialistId}_${DateTime.now().microsecondsSinceEpoch}_specialist',
        specialistId: specialistId,
        text: replyText,
        fromMe: false,
        sentAt: DateTime.now(),
      );

      final withReply = [
        ...(_rooms[specialistId] ?? []),
        replyMessage,
      ];
      _rooms[specialistId] = withReply;

      if (!isClosed) {
        emit(SpecialistChatState.active(
          specialistId: specialistId,
          messages: List<ChatMessage>.from(withReply),
        ));
      }
    });
  }
}

// Cubit for the consultation text-chat room.
//
// Subscribes to the Supabase Realtime stream for a given bookingId and emits
// [ConsultationChatActive] on every new list of messages.  Calls
// [ConsultationChatRepository.sendMessage] to insert patient messages; the
// newly inserted row arrives back through the Realtime stream — no optimistic
// duplication is needed.
//
// 🔒 MEDICALLY SENSITIVE — all messages are doctor-patient conversation data.
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opto/features/consultation/domain/repositories/consultation_chat_repository.dart';

export 'consultation_chat_state.dart';

/// Cubit that drives the consultation text-chat room.
///
/// Lifecycle:
///   1. [open] — subscribe to the Realtime stream; emits [loading] then
///      [active] on each message list update.
///   2. [sendMessage] — insert a new message; the inserted row returns via the
///      existing stream subscription (no optimistic duplicate needed).
///   3. [close] — cancels the stream subscription automatically before the
///      cubit is closed (override of [Cubit.close]).
class ConsultationChatCubit extends Cubit<ConsultationChatState> {
  ConsultationChatCubit(this._repo) : super(const ConsultationChatState.initial());

  final ConsultationChatRepository _repo;

  StreamSubscription<dynamic>? _subscription;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Opens the chat room for [bookingId].
  ///
  /// Emits [ConsultationChatLoading], then [ConsultationChatActive] for every
  /// batch of messages received from the Realtime stream.
  /// Emits [ConsultationChatError] if the stream encounters an error.
  void open(String bookingId) {
    if (isClosed) return;
    emit(const ConsultationChatState.loading());

    final currentUserId = _repo.currentUserId;

    _subscription?.cancel();
    _subscription = _repo.watchMessages(bookingId).listen(
      (messages) {
        if (isClosed) return;
        emit(ConsultationChatState.active(
          bookingId: bookingId,
          currentUserId: currentUserId,
          messages: messages,
        ));
      },
      onError: (Object e) {
        if (isClosed) return;
        emit(ConsultationChatState.error(e.toString()));
      },
    );
  }

  /// Sends a new message in the currently open chat room.
  ///
  /// The inserted row will arrive back via the existing Realtime subscription,
  /// so the UI updates automatically without optimistic insertion.
  /// Emits [ConsultationChatError] on failure (reverts to active if currently active).
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final current = state;
    if (current is! ConsultationChatActive) return;

    try {
      await _repo.sendMessage(
        bookingId: current.bookingId,
        body: trimmed,
      );
    } catch (e) {
      if (isClosed) return;
      emit(ConsultationChatState.error(e.toString()));
      // Restore active state so the user can retry.
      emit(current);
    }
  }

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

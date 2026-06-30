// States for [ConsultationChatCubit].
//
// Uses `freezed` sealed union — mirrors booking_state.dart pattern.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/consultation/domain/entities/consultation_message_entity.dart';

part 'consultation_chat_state.freezed.dart';

@freezed
sealed class ConsultationChatState with _$ConsultationChatState {
  /// Initial state before the chat room is opened.
  const factory ConsultationChatState.initial() = ConsultationChatInitial;

  /// Loading messages for the first time.
  const factory ConsultationChatState.loading() = ConsultationChatLoading;

  /// Chat room open and messages available (may be empty list).
  ///
  /// [currentUserId] is used by the UI to derive [fromMe] for each bubble
  /// without importing the Supabase client.
  const factory ConsultationChatState.active({
    required String bookingId,
    required String? currentUserId,
    required List<ConsultationMessageEntity> messages,
  }) = ConsultationChatActive;

  /// A chat operation failed.
  const factory ConsultationChatState.error(String message) =
      ConsultationChatError;
}

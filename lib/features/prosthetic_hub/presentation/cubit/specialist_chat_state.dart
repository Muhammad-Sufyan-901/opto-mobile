// States for [SpecialistChatCubit].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/chat_message.dart';

part 'specialist_chat_state.freezed.dart';

@freezed
sealed class SpecialistChatState with _$SpecialistChatState {
  /// No room open yet; initial state before [SpecialistChatCubit.openRoom].
  const factory SpecialistChatState.empty() = SpecialistChatEmpty;

  /// A chat room is open and messages are available (possibly an empty list).
  const factory SpecialistChatState.active({
    required String specialistId,
    required List<ChatMessage> messages,
  }) = SpecialistChatActive;
}

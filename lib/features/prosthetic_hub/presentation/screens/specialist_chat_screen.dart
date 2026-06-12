// Screen: Specialist Chat (Prosthetic Hub — Message My Specialist flow)
//
// Per-specialist chat room — messages rendered as [ChatBubble]s, new messages
// composed via [ChatComposer]. State is in-memory via [SpecialistChatCubit].
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/specialist_chat_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/chat_bubble.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/chat_composer.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen: Specialist Chat room.
///
/// Outer widget reads [Specialist] from [GoRouterState.extra] and creates the
/// [BlocProvider]. Inner [StatefulWidget] handles the scroll, announcements,
/// and message sending.
class SpecialistChatScreen extends StatelessWidget {
  const SpecialistChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is! Specialist) {
      // extra is missing or wrong type (e.g. after hot restart or deep link)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return BlocProvider<SpecialistChatCubit>(
      create: (_) => sl<SpecialistChatCubit>()..openRoom(extra.id),
      child: _ChatView(specialist: extra),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({required this.specialist});

  final Specialist specialist;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Chat with ${widget.specialist.fullName}.');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final specialist = widget.specialist;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.screenPadding,
                right: AppDimensions.screenPadding,
                top: 16,
                bottom: 8,
              ),
              child: ProstheticHeader(title: specialist.fullName),
            ),

            // ── Divider ───────────────────────────────────────────────────
            Divider(height: 1, thickness: 1, color: cs.outlineVariant),

            // ── Message list ──────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<SpecialistChatCubit, SpecialistChatState>(
                listener: (context, state) {
                  if (state is SpecialistChatActive) {
                    final msgs = state.messages;
                    // Auto-scroll when new messages arrive.
                    if (msgs.length > _lastMessageCount) {
                      _lastMessageCount = msgs.length;
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToBottom(),
                      );
                      // Announce incoming specialist messages to screen reader.
                      if (msgs.isNotEmpty && !msgs.last.fromMe) {
                        final lastMsg = msgs.last;
                        announce(
                          context,
                          'Message from ${specialist.fullName}: ${lastMsg.text}',
                        );
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (state is! SpecialistChatActive) {
                    return const SizedBox.shrink();
                  }
                  final messages = state.messages;
                  if (messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppDimensions.screenPadding,
                        ),
                        child: Text(
                          'Send a message to start the conversation.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.space12,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        ChatBubble(message: messages[index]),
                  );
                },
              ),
            ),

            // ── Composer ──────────────────────────────────────────────────
            ChatComposer(
              onSend: (text) {
                context.read<SpecialistChatCubit>().sendMessage(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}

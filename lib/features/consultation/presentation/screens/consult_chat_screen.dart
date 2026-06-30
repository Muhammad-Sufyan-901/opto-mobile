// Screen: Consultation Text-Chat Room (Screen 18d)
//
// Opened when the patient selects ConsultMode.nonVerbal and their booking is
// confirmed.  Provides a real-time message list backed by Supabase Realtime
// and a composer to send new messages.
//
// Receives { 'doctor': DoctorEntity, 'bookingId': String } via GoRouter extra.
//
// Pattern mirrors lib/features/prosthetic_hub/presentation/screens/
// specialist_chat_screen.dart — outer StatelessWidget reads extra + provides
// BLoC; inner StatefulWidget owns scroll + announcements.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/cubit/consultation_chat_cubit.dart';
import 'package:opto/features/consultation/presentation/widgets/consult_chat_bubble.dart';
import 'package:opto/features/consultation/presentation/widgets/consult_chat_composer.dart';

/// Screen: Consultation Text-Chat Room.
///
/// Outer widget reads [DoctorEntity] and bookingId from [GoRouterState.extra]
/// and creates the [BlocProvider].  Inner [StatefulWidget] handles scroll,
/// announcements, and message sending.
class ConsultChatScreen extends StatelessWidget {
  const ConsultChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is! Map<String, dynamic>) {
      // Missing or wrong extra (hot restart, deep link): bail safely.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final doctor = extra['doctor'] as DoctorEntity?;
    final bookingId = extra['bookingId'] as String?;

    if (doctor == null || bookingId == null || bookingId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return BlocProvider<ConsultationChatCubit>(
      create: (_) => sl<ConsultationChatCubit>()..open(bookingId),
      child: _ConsultChatView(doctor: doctor),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _ConsultChatView extends StatefulWidget {
  const _ConsultChatView({required this.doctor});

  final DoctorEntity doctor;

  @override
  State<_ConsultChatView> createState() => _ConsultChatViewState();
}

class _ConsultChatViewState extends State<_ConsultChatView> {
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final name = widget.doctor.fullName ?? 'your doctor';
      announce(context, 'Text chat with $name.');
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
    final doctor = widget.doctor;
    final doctorName = doctor.fullName ?? 'Doctor';

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
              child: _ChatHeader(doctorName: doctorName, cs: cs, theme: theme),
            ),

            // ── Divider ───────────────────────────────────────────────────
            Divider(height: 1, thickness: 1, color: cs.outlineVariant),

            // ── Message list ──────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<ConsultationChatCubit, ConsultationChatState>(
                listener: (context, state) {
                  if (state is ConsultationChatActive) {
                    final msgs = state.messages;
                    if (msgs.length > _lastMessageCount) {
                      _lastMessageCount = msgs.length;
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToBottom(),
                      );
                      // Announce incoming doctor messages to the screen reader.
                      if (msgs.isNotEmpty) {
                        final last = msgs.last;
                        final fromMe = last.senderId == state.currentUserId;
                        if (!fromMe) {
                          announce(
                            context,
                            'Message from $doctorName: ${last.body}',
                          );
                        }
                      }
                    }
                  }
                  if (state is ConsultationChatError) {
                    announce(context, 'Error: ${state.message}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ConsultationChatLoading ||
                      state is ConsultationChatInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ConsultationChatError) {
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.screenPadding),
                        child: Text(
                          'Could not load messages. Please try again.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (state is! ConsultationChatActive) {
                    return const SizedBox.shrink();
                  }
                  final messages = state.messages;
                  final currentUserId = state.currentUserId;

                  if (messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.screenPadding),
                        child: Text(
                          'Send a message to start the consultation.',
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
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final fromMe = msg.senderId == currentUserId;
                      return ConsultChatBubble(
                        message: msg,
                        fromMe: fromMe,
                      );
                    },
                  );
                },
              ),
            ),

            // ── Composer ──────────────────────────────────────────────────
            ConsultChatComposer(
              onSend: (text) {
                context.read<ConsultationChatCubit>().sendMessage(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.doctorName,
    required this.cs,
    required this.theme,
  });

  final String doctorName;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: 'Text chat with $doctorName',
      child: Row(
        children: [
          // ── Back button ────────────────────────────────────────────────
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) context.pop();
              },
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Title ──────────────────────────────────────────────────────
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doctorName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    'Text Consultation',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Trailing spacer (balances back button) ─────────────────────
          const SizedBox(width: AppDimensions.minTapTarget),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Blue-gradient hero card for the featured thread on Community Home.
class FeaturedHeroCard extends StatelessWidget {
  const FeaturedHeroCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  final PostEntity post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      label:
          'Featured this week: ${post.title ?? post.body}. ${post.likeCount} found this helpful. Tap to read thread.',
      button: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.35),
                blurRadius: 46,
                offset: const Offset(0, 22),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Featured this week" tag
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_outlined,
                        color: Colors.white, size: 15),
                    const SizedBox(width: 6),
                    Text(
                      'Featured this week',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              Text(
                post.title ?? post.body,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.15,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                '${post.authorName ?? "Community"} · ${post.topic ?? "Community"}'
                '${post.voiceUrl != null ? " · voice note" : ""}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // Avatar stack + helpful count
              ExcludeSemantics(
                child: Row(
                  children: [
                    _AvatarStack(likeCount: post.likeCount),
                    const SizedBox(width: 11),
                    Text(
                      '${post.likeCount} found this helpful',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // "Read thread" button
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Read thread',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: cs.primary, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.likeCount});
  final int likeCount;

  @override
  Widget build(BuildContext context) {
    // Show 3 placeholder mini avatars
    final colors = [
      const Color(0xFF16A34A),
      const Color(0xFF7C3AED),
      const Color(0xFFE07B39),
    ];
    return SizedBox(
      width: 3 * 34 - 2 * 11.0,
      height: 34,
      child: Stack(
        children: List.generate(
            colors.length,
            (i) => Positioned(
                  left: i * (34 - 11).toDouble(),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colors[i],
                      shape: BoxShape.circle,
                      border: const Border.fromBorderSide(
                        BorderSide(color: Color(0xFF1E6AC5), width: 2.5),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}

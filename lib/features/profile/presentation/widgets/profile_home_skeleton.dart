import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Profile Home skeleton loading state (CSS: `PrHomeLoading`).
///
/// A shimmer-style placeholder matching the P1 profile shape, shown while
/// [ProfileBloc] is in the loading state. Uses an animated opacity pulse
/// so reduced-motion users still get visual feedback without animation when
/// the system disables it.
class ProfileHomeSkeleton extends StatefulWidget {
  const ProfileHomeSkeleton({super.key});

  @override
  State<ProfileHomeSkeleton> createState() => _ProfileHomeSkeletonState();
}

class _ProfileHomeSkeletonState extends State<ProfileHomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();
    final Color shimmer =
        ext?.blueTint ?? cs.primaryContainer.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: const HomeBottomNav(activeTab: 4),
      body: SafeArea(
        child: Semantics(
          label: 'Loading profile…',
          child: FadeTransition(
            opacity: _opacity,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App bar row
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Bone(w: 90, h: 20, r: 9, color: shimmer),
                      const Spacer(),
                      _BoneCircle(d: 40, color: shimmer),
                      const SizedBox(width: 8),
                      _BoneCircle(d: 40, color: shimmer),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Loading progress bar
                  LinearProgressIndicator(
                    backgroundColor: shimmer,
                    color: cs.primary.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 20),

                  // Identity header
                  Column(
                    children: [
                      _BoneCircle(d: 96, color: shimmer),
                      const SizedBox(height: 16),
                      _Bone(
                          w: MediaQuery.of(context).size.width * 0.46,
                          h: 20,
                          r: 9,
                          color: shimmer),
                      const SizedBox(height: 8),
                      _Bone(
                          w: MediaQuery.of(context).size.width * 0.34,
                          h: 13,
                          r: 7,
                          color: shimmer),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Bone(w: 80, h: 32, r: 16, color: shimmer),
                          const SizedBox(width: 8),
                          _Bone(w: 88, h: 32, r: 16, color: shimmer),
                          const SizedBox(width: 8),
                          _Bone(w: 72, h: 32, r: 16, color: shimmer),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Listen button
                  _Bone(w: 200, h: 40, r: 20, color: shimmer),
                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                          child: _Bone(h: 54, r: 27, color: shimmer)),
                      const SizedBox(width: 12),
                      _Bone(w: 60, h: 54, r: 27, color: shimmer),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Stats strip
                  _Bone(h: 74, r: 22, color: shimmer),
                  const SizedBox(height: 14),

                  // Glance card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: shimmer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _Bone(w: 120, h: 12, r: 6, color: shimmer),
                            _Bone(w: 54, h: 12, r: 6, color: shimmer),
                          ],
                        ),
                        const SizedBox(height: 14),
                        for (int i = 0; i < 3; i++) ...[
                          if (i > 0) const SizedBox(height: 13),
                          Row(
                            children: [
                              _BoneCircle(d: 26, r: 8, color: shimmer),
                              const SizedBox(width: 12),
                              _Bone(w: 90, h: 11, r: 6, color: shimmer),
                              const Spacer(),
                              _Bone(w: 100, h: 11, r: 6, color: shimmer),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Section label
                  _Bone(w: 160, h: 11, r: 6, color: shimmer),
                  const SizedBox(height: 14),

                  // Nav rows
                  for (int i = 0; i < 4; i++) ...[
                    if (i > 0) const SizedBox(height: 11),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: shimmer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          _BoneCircle(d: 50, r: 16, color: shimmer),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Bone(h: 14, r: 7, color: shimmer),
                                const SizedBox(height: 8),
                                _Bone(
                                    w: 140,
                                    h: 11,
                                    r: 6,
                                    color: shimmer),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _BoneCircle(d: 20, color: shimmer),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bone helpers ──────────────────────────────────────────────────────────────

class _Bone extends StatelessWidget {
  const _Bone({
    this.w,
    required this.h,
    this.r = 8,
    required this.color,
  });

  final double? w;
  final double h;
  final double r;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}

class _BoneCircle extends StatelessWidget {
  const _BoneCircle({required this.d, this.r, required this.color});

  final double d;
  final double? r;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            r != null ? BorderRadius.circular(r!) : BorderRadius.circular(d / 2),
      ),
    );
  }
}

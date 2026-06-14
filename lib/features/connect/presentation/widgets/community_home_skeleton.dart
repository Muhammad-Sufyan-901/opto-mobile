import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Full-page skeleton for the Community Home screen while data loads.
class CommunityHomeSkeleton extends StatefulWidget {
  const CommunityHomeSkeleton({super.key});

  @override
  State<CommunityHomeSkeleton> createState() => _CommunityHomeSkeletonState();
}

class _CommunityHomeSkeletonState extends State<CommunityHomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();
    final skBase =
        ext?.blueTint ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final skSheen = Colors.white.withValues(alpha: 0.6);

    return Semantics(
      label: 'Loading community feed',
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, _) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero skeleton
                  _SkBlock(
                      h: 180,
                      r: 30,
                      base: skBase,
                      sheen: skSheen,
                      anim: _anim),
                  const SizedBox(height: 16),
                  // Section label
                  _SkLine(
                      w: 0.3,
                      h: 11,
                      base: skBase,
                      sheen: skSheen,
                      anim: _anim),
                  const SizedBox(height: 12),
                  // Circle tiles row
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: List.generate(
                          3,
                          (i) => Padding(
                                padding:
                                    EdgeInsets.only(right: i < 2 ? 12 : 0),
                                child: _SkBlock(
                                    w: 150,
                                    h: 120,
                                    r: 22,
                                    base: skBase,
                                    sheen: skSheen,
                                    anim: _anim),
                              )),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ask prompt
                  _SkBlock(
                      h: 66,
                      r: 24,
                      base: skBase,
                      sheen: skSheen,
                      anim: _anim),
                  const SizedBox(height: 16),
                  // Section label
                  _SkLine(
                      w: 0.28,
                      h: 11,
                      base: skBase,
                      sheen: skSheen,
                      anim: _anim),
                  const SizedBox(height: 12),
                  // Thread card skeletons
                  _SkThreadCard(base: skBase, sheen: skSheen, anim: _anim),
                  const SizedBox(height: 13),
                  _SkThreadCard(base: skBase, sheen: skSheen, anim: _anim),
                  const SizedBox(height: 20),
                  // Loading footer
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Loading your community…',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: ext?.ink3 ??
                                    Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkLine extends StatelessWidget {
  const _SkLine({
    required this.w, // fraction of available width (0.0–1.0)
    required this.base,
    required this.sheen,
    required this.anim,
    this.h = 13,
  });
  final double w;
  final double h;
  final Color base;
  final Color sheen;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return _SkBlock(
        w: constraints.maxWidth * w,
        h: h,
        r: 7,
        base: base,
        sheen: sheen,
        anim: anim,
      );
    });
  }
}

class _SkBlock extends StatelessWidget {
  const _SkBlock({
    required this.h,
    required this.base,
    required this.sheen,
    required this.anim,
    this.w,
    this.r = 12,
  });
  final double? w;
  final double h;
  final double r;
  final Color base;
  final Color sheen;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(r),
      ),
      clipBehavior: Clip.hardEdge,
      child: AnimatedBuilder(
        animation: anim,
        builder: (context, child) => Transform.translate(
          offset: Offset(anim.value * 400 - 150, 0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, sheen, Colors.transparent],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkThreadCard extends StatelessWidget {
  const _SkThreadCard({
    required this.base,
    required this.sheen,
    required this.anim,
  });
  final Color base;
  final Color sheen;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();
    final borderColor =
        ext?.line ?? Theme.of(context).colorScheme.outlineVariant;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ext?.blueTint ??
            Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _SkBlock(
                w: 44, h: 44, r: 22, base: base, sheen: sheen, anim: anim),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _SkLine(w: 0.44, base: base, sheen: sheen, anim: anim),
                  const SizedBox(height: 6),
                  _SkLine(
                      w: 0.30, h: 11, base: base, sheen: sheen, anim: anim),
                ])),
          ]),
          const SizedBox(height: 10),
          _SkLine(w: 0.92, h: 16, base: base, sheen: sheen, anim: anim),
          const SizedBox(height: 6),
          _SkLine(w: 0.78, h: 16, base: base, sheen: sheen, anim: anim),
          const SizedBox(height: 10),
          _SkBlock(h: 70, r: 18, base: base, sheen: sheen, anim: anim),
          const SizedBox(height: 10),
          Row(children: [
            _SkBlock(
                w: 70, h: 36, r: 18, base: base, sheen: sheen, anim: anim),
            const SizedBox(width: 8),
            _SkBlock(
                w: 70, h: 36, r: 18, base: base, sheen: sheen, anim: anim),
          ]),
        ],
      ),
    );
  }
}

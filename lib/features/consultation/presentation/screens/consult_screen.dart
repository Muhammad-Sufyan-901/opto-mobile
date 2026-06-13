import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_bloc.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_cubit.dart';
import 'package:opto/features/consultation/presentation/widgets/doctor_card.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen C1 — Find a Doctor (Health & Consultation hub).
///
/// Voice-first specialist directory for blind, low-vision & ocular-prosthetic
/// users. Features a gradient "Start voice consult" hero, specialty chip
/// filter, search, and a live doctor list from [DoctorSearchBloc].
class ConsultScreen extends StatelessWidget {
  const ConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorSearchBloc>(
          create: (_) => sl<DoctorSearchBloc>()
            ..add(const DoctorSearchEvent.loadDoctors()),
        ),
        BlocProvider<BookingCubit>(
          create: (_) => sl<BookingCubit>()..loadMyBookings(),
        ),
      ],
      child: const _ConsultView(),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _ConsultView extends StatefulWidget {
  const _ConsultView();

  @override
  State<_ConsultView> createState() => _ConsultViewState();
}

class _ConsultViewState extends State<_ConsultView> {
  String _selectedSpecialty = 'All';

  static const List<String> _specialties = [
    'All',
    'Ocular prosthetics',
    'Low vision',
    'Retina',
    'Glaucoma',
  ];

  /// Mock doctor metadata indexed by position — replaces missing backend fields.
  /// TODO(backend): hydrate isOnline, rating, reviewCount from doctor_stats join.
  static const List<_MockDocMeta> _mockMeta = [
    _MockDocMeta(
        isOnline: true, rating: 4.9, reviews: 320, avail: 'Available now'),
    _MockDocMeta(
        isOnline: true, rating: 4.8, reviews: 210, avail: 'Available now'),
    _MockDocMeta(isOnline: false, rating: 4.9, reviews: 415, avail: 'In 10 min'),
    _MockDocMeta(
        isOnline: false, rating: 4.7, reviews: 118, avail: 'In 30 min'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context,
          'Talk to a Doctor. Specialist directory. Swipe to explore specialists or start a voice consult immediately.');
    });
  }

  List<DoctorEntity> _filtered(List<DoctorEntity> doctors) {
    if (_selectedSpecialty == 'All') return doctors;
    return doctors
        .where((d) => d.specialty
            .toLowerCase()
            .contains(_selectedSpecialty.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: const HomeBottomNav(activeTab: 3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Large title bar ──────────────────────────────────────────────
            _LargeTitleBar(cs: cs, ext: ext, theme: theme),

            // ── Scrollable content ───────────────────────────────────────────
            Expanded(
              child: BlocBuilder<DoctorSearchBloc, DoctorSearchState>(
                builder: (context, state) {
                  final isLoading = state is DoctorSearchLoading ||
                      state is DoctorSearchInitial;

                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.screenPadding,
                          12,
                          AppDimensions.screenPadding,
                          0,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Search field
                            _SearchField(cs: cs, ext: ext, theme: theme),

                            const SizedBox(height: AppDimensions.space16),

                            // Voice-first hero
                            _VoiceHero(cs: cs),

                            const SizedBox(height: AppDimensions.space16),

                            // Specialty chips
                            _SpecialtyChips(
                              specialties: _specialties,
                              selected: _selectedSpecialty,
                              onSelect: (s) =>
                                  setState(() => _selectedSpecialty = s),
                              cs: cs,
                              ext: ext,
                              theme: theme,
                            ),

                            const SizedBox(height: AppDimensions.space16),

                            // Section header
                            _SectionRow(cs: cs, theme: theme),

                            const SizedBox(height: AppDimensions.space12),
                          ]),
                        ),
                      ),

                      // Doctor list or loading skeleton
                      if (isLoading)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPadding,
                          ),
                          sliver: _DoctorSkeleton(cs: cs, ext: ext),
                        )
                      else if (state is DoctorSearchError)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPadding,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Text(
                                  state.message,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: cs.error,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Semantics(
                                  button: true,
                                  label: 'Retry loading doctors',
                                  child: TextButton(
                                    onPressed: () =>
                                        context.read<DoctorSearchBloc>().add(
                                              const DoctorSearchEvent
                                                  .loadDoctors(),
                                            ),
                                    child: const Text('Retry'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (state is DoctorSearchLoaded)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.screenPadding,
                            0,
                            AppDimensions.screenPadding,
                            AppDimensions.space32,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) {
                                final doctors = _filtered(state.doctors);
                                if (i >= doctors.length) return null;
                                final doc = doctors[i];
                                final meta = _mockMeta[
                                    i.clamp(0, _mockMeta.length - 1)];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppDimensions.space12,
                                  ),
                                  child: DoctorCard(
                                    doctor: doc,
                                    isOnline: meta.isOnline,
                                    rating: meta.rating,
                                    reviewCount: meta.reviews,
                                    availabilityLabel: meta.avail,
                                  ),
                                );
                              },
                              childCount: _filtered(state.doctors).length,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
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

/// Large Material-3 title bar ("Talk to a Doctor") with listen + filter actions.
class _LargeTitleBar extends StatelessWidget {
  const _LargeTitleBar({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color onTint = cs.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: [
                const Spacer(),
                // Listen button
                Semantics(
                  button: true,
                  label: 'Listen: Talk to a Doctor. Licensed eye-care specialists, on call.',
                  child: GestureDetector(
                    onTap: () {
                      HapticPatterns.focusTick();
                      SemanticsService.announce(
                        'Talk to a Doctor. Licensed eye-care specialists, on call.',
                        TextDirection.ltr,
                      );
                    },
                    child: Container(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      decoration: BoxDecoration(
                        color: blueTint,
                        shape: BoxShape.circle,
                      ),
                      child: ExcludeSemantics(
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: AppDimensions.iconLg,
                          color: onTint,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Filter
                Semantics(
                  button: true,
                  label: 'Filter specialists',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(consult): open filter sheet
                    },
                    child: SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: Center(
                        child: ExcludeSemantics(
                          child: Icon(
                            Icons.tune_rounded,
                            size: AppDimensions.iconLg,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Large title
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPadding,
              2,
              AppDimensions.screenPadding,
              0,
            ),
            child: ExcludeSemantics(
              child: Text(
                'Talk to a Doctor',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  letterSpacing: -1.0,
                  height: 1.1,
                ),
              ),
            ),
          ),
          // Subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPadding,
              4,
              AppDimensions.screenPadding,
              12,
            ),
            child: ExcludeSemantics(
              child: Text(
                'Licensed eye-care specialists, on call',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ext?.ink2 ?? cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded search field with mic button.
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      textField: true,
      label: 'Search name, specialty or symptom',
      child: GestureDetector(
        onTap: () {
          // TODO(consult): open search overlay
        },
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: line, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    size: AppDimensions.iconLg, color: ink3),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Text(
                    'Search name, specialty or symptom',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ink3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic_none_rounded,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient "Start voice consult" connect-now hero card.
class _VoiceHero extends StatelessWidget {
  const _VoiceHero({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'Fastest help. Connect with the next available specialist. Voice call, average wait under 2 minutes. Start voice consult.',
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          SemanticsService.announce(
            'Starting voice consult. Connecting you to the next available specialist.',
            TextDirection.ltr,
          );
          context.push(AppRoutes.consultConnecting.path,
              extra: {'doctor': null});
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 6),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.secondary],
              stops: const [0.0, 0.78],
            ),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.40),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FASTEST HELP',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Connect with the next available specialist',
                            style:
                                theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Voice call · avg. wait under 2 minutes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space16),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.call_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
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
                        'Start voice consult',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                          fontSize: 16.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          size: 20, color: cs.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrollable specialty filter chips.
class _SpecialtyChips extends StatelessWidget {
  const _SpecialtyChips({
    required this.specialties,
    required this.selected,
    required this.onSelect,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final List<String> specialties;
  final String selected;
  final ValueChanged<String> onSelect;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final s in specialties)
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: Semantics(
                button: true,
                selected: s == selected,
                label: s == selected ? '$s, selected' : s,
                child: GestureDetector(
                  onTap: () => onSelect(s),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: s == selected
                          ? cs.primary
                          : (ext?.blueTint ?? cs.primaryContainer),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: s == selected
                            ? cs.primary
                            : (ext?.line ?? cs.outline),
                        width: 1.5,
                      ),
                    ),
                    child: ExcludeSemantics(
                      child: Center(
                        child: Text(
                          s,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: s == selected
                                ? Colors.white
                                : (ext?.ink2 ?? cs.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// "Specialists" label + "Sort: Soonest" row.
class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.cs, required this.theme});

  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExcludeSemantics(
          child: Text(
            'SPECIALISTS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Sort specialists',
          child: GestureDetector(
            onTap: () {
              // TODO(consult): open sort sheet
            },
            child: SizedBox(
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Text(
                    'Sort: Soonest',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer skeleton for the doctor list loading state.
class _DoctorSkeleton extends StatefulWidget {
  const _DoctorSkeleton({required this.cs, required this.ext});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  State<_DoctorSkeleton> createState() => _DoctorSkeletonState();
}

class _DoctorSkeletonState extends State<_DoctorSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _shimmer = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.of(context).disableAnimations) {
      _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: _SkeletonCard(shimmer: _shimmer, cs: widget.cs, ext: widget.ext),
        ),
        childCount: 3,
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    required this.shimmer,
    required this.cs,
    required this.ext,
  });

  final Animation<double> shimmer;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    final Color base = ext?.blueTint ?? cs.primaryContainer;

    return Semantics(
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: shimmer,
        builder: (_, __) {
          return Container(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            decoration: BoxDecoration(
              color: base,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusCard),
              border: Border.all(
                color: ext?.line ?? cs.outline,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar skeleton
                _ShimmerBox(
                  width: 58,
                  height: 58,
                  radius: 29,
                  shimmer: shimmer,
                  cs: cs,
                  ext: ext,
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _ShimmerBox(
                        width: null,
                        widthFraction: 0.66,
                        height: 14,
                        radius: 7,
                        shimmer: shimmer,
                        cs: cs,
                        ext: ext,
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(
                        width: null,
                        widthFraction: 0.48,
                        height: 12,
                        radius: 6,
                        shimmer: shimmer,
                        cs: cs,
                        ext: ext,
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(
                        width: null,
                        widthFraction: 0.38,
                        height: 10,
                        radius: 5,
                        shimmer: shimmer,
                        cs: cs,
                        ext: ext,
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(
                        width: 110,
                        height: 26,
                        radius: 13,
                        shimmer: shimmer,
                        cs: cs,
                        ext: ext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.height,
    required this.radius,
    required this.shimmer,
    required this.cs,
    required this.ext,
    this.width,
    this.widthFraction,
  });

  final double? width;
  final double? widthFraction;
  final double height;
  final double radius;
  final Animation<double> shimmer;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    final Color base = ext?.line ?? cs.outline;
    final screenW = MediaQuery.of(context).size.width;
    final double w =
        width ?? ((widthFraction ?? 1.0) * (screenW - 2 * AppDimensions.screenPadding));

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            base.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0.65),
            base.withValues(alpha: 0.5),
          ],
          stops: [
            math.max(0, shimmer.value - 0.3),
            shimmer.value.clamp(0.0, 1.0),
            math.min(1, shimmer.value + 0.3),
          ],
        ).createShader(bounds);
      },
      child: Container(
        width: w,
        height: height,
        decoration: BoxDecoration(
          color: base.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Simple data holder for mock doctor metadata.
class _MockDocMeta {
  const _MockDocMeta({
    required this.isOnline,
    required this.rating,
    required this.reviews,
    required this.avail,
  });

  final bool isOnline;
  final double rating;
  final int reviews;
  final String avail;
}

// Catalog Screen — Prosthetic Hub product listing.
//
// Accessibility-first: every tap target ≥ 48dp, all interactive elements
// have Semantics labels, audio_description is announced on focus via
// Semantics(label: ...), and the screen announces itself on first load.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/catalog/catalog_bloc.dart';

/// Screen — Prosthetic Hub product catalog listing.
///
/// Provides a [CatalogBloc] from DI (via [BlocProvider] in the route), fires
/// [LoadCatalog] on init, and presents a filterable [ListView] of products.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  ProductType? _typeFilter;
  String? _irisColorFilter;
  String? _sizeFilter;

  bool _announced = false;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _announced) return;
      _announced = true;
      announce(context, 'Prosthetic catalogue.');
    });
  }

  void _loadCatalog() {
    context.read<CatalogBloc>().add(
          CatalogEvent.loadCatalog(
            typeFilter: _typeFilter,
            irisColorFilter: _irisColorFilter,
            sizeFilter: _sizeFilter,
          ),
        );
  }

  void _applyTypeFilter(ProductType? type) {
    setState(() => _typeFilter = type);
    _loadCatalog();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            _CatalogHeader(cs: cs),

            // ── Filter chips ─────────────────────────────────────────────────
            _FilterBar(
              selectedType: _typeFilter,
              onTypeSelected: _applyTypeFilter,
            ),

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<CatalogBloc, CatalogState>(
                listener: (context, state) {
                  // No side-effect listeners needed at this stage.
                },
                builder: (context, state) {
                  return switch (state) {
                    CatalogInitial() => const SizedBox.shrink(),
                    CatalogLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    CatalogLoaded(:final products) => products.isEmpty
                        ? _EmptyState(cs: cs)
                        : _ProductList(products: products),
                    ProductLoaded() => const SizedBox.shrink(),
                    CatalogError(:final message) => _ErrorState(
                        message: message,
                        onRetry: _loadCatalog,
                      ),
                  };
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

/// Screen header: back button + centred title.
class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 22,
        top: 14,
        bottom: 4,
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.prostheticHub.path);
                }
              },
              child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.chevron_left, size: 28),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                'Product Catalog',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: AppDimensions.minTapTarget,
            height: AppDimensions.minTapTarget,
          ),
        ],
      ),
    );
  }
}

/// Horizontal filter bar for [ProductType].
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedType,
    required this.onTypeSelected,
  });

  final ProductType? selectedType;
  final ValueChanged<ProductType?> onTypeSelected;

  static const _labels = {
    null: 'All',
    ProductType.prosthesis: 'Prosthesis',
    ProductType.selfCleaningCase: 'Cleaning Case',
    ProductType.careKit: 'Care Kit',
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingMin,
        vertical: AppDimensions.space8,
      ),
      child: SizedBox(
        height: AppDimensions.minTapTarget,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _labels.entries.map((entry) {
            final isSelected = selectedType == entry.key;
            final label = entry.value;
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.space8),
              child: Semantics(
                button: true,
                selected: isSelected,
                label: 'Filter: $label${isSelected ? ', selected' : ''}',
                child: GestureDetector(
                  onTap: () => onTypeSelected(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                      vertical: AppDimensions.space8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primary : cs.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusChip,
                      ),
                      border: Border.all(
                        color: isSelected ? cs.primary : cs.outline,
                        width: 1.5,
                      ),
                    ),
                    child: ExcludeSemantics(
                      child: Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? cs.onPrimary : cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Scrollable list of product rows.
class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<ProstheticProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingMin,
        vertical: AppDimensions.space8,
      ),
      itemCount: products.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimensions.space12),
      itemBuilder: (context, index) =>
          _ProductRow(product: products[index]),
    );
  }
}

/// Single product row card.
class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final ProstheticProductEntity product;

  static const _typeIcons = {
    ProductType.prosthesis: Icons.visibility_outlined,
    ProductType.selfCleaningCase: Icons.cleaning_services_outlined,
    ProductType.careKit: Icons.medical_services_outlined,
  };

  static const _typeLabels = {
    ProductType.prosthesis: 'Prosthesis',
    ProductType.selfCleaningCase: 'Cleaning Case',
    ProductType.careKit: 'Care Kit',
  };

  String _formatPrice(int priceIdr) {
    // Format as IDR with thousand separators.
    final parts = priceIdr.toString().split('');
    final buffer = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final icon = _typeIcons[product.type] ?? Icons.inventory_2_outlined;
    final typeLabel = _typeLabels[product.type] ?? product.type.dbValue;

    // Semantics label includes the audio description so TalkBack users
    // hear the richer description on focus rather than just the product name.
    final semanticsLabel =
        '${product.name}. $typeLabel. ${_formatPrice(product.priceIdr)}. '
        '${product.audioDescription}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: () => context.goNamed(
          AppRoutes.prostheticProductDetail.name,
          pathParameters: {'productId': product.id},
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Icon chip ──────────────────────────────────────────────
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusChip),
                  ),
                  child: Icon(icon, size: 22, color: cs.secondary),
                ),
              ),

              const SizedBox(width: 14),

              // ── Text column ───────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        typeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatPrice(product.priceIdr),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ──────────────────────────────────────
              ExcludeSemantics(
                child: Icon(Icons.chevron_right, size: 22, color: ink3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state widget shown when no products match the current filter.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: AppDimensions.space16),
              Text(
                'No products found',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Try adjusting your filters.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error state widget with a retry button.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: AppDimensions.space16),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Retry loading catalog',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: const ExcludeSemantics(
                      child: Text('Retry'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

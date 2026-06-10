// Product Detail Screen — Prosthetic Hub individual product view.
//
// Accessibility-first: announces product name on load, all interactive
// elements have Semantics labels, audio_description has a dedicated labeled
// card, and all tap targets are ≥ 48dp.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/vendor_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/catalog/catalog_bloc.dart';

/// Screen — Prosthetic Hub product detail view.
///
/// Receives [productId] from GoRouter path parameters and adds [LoadProduct]
/// to the [CatalogBloc] on init.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<CatalogBloc>()
        .add(CatalogEvent.loadProduct(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        return switch (state) {
          CatalogLoading() || CatalogInitial() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ProductLoaded(:final product, :final vendor) =>
            _DetailContent(product: product, vendor: vendor),
          CatalogError(:final message) =>
            _ErrorScaffold(message: message, productId: widget.productId),
          _ => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        };
      },
      buildWhen: (prev, curr) =>
          curr is ProductLoaded ||
          curr is CatalogLoading ||
          curr is CatalogError ||
          curr is CatalogInitial,
    );
  }
}

// =============================================================================
// DETAIL CONTENT
// =============================================================================

class _DetailContent extends StatefulWidget {
  const _DetailContent({
    required this.product,
    this.vendor,
  });

  final ProstheticProductEntity product;
  final VendorEntity? vendor;

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> {
  bool _announced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _announced) return;
      _announced = true;
      announce(context, '${widget.product.name}.');
    });
  }

  static const _typeLabels = {
    ProductType.prosthesis: 'Prosthesis',
    ProductType.selfCleaningCase: 'Cleaning Case',
    ProductType.careKit: 'Care Kit',
  };

  String _formatPrice(int priceIdr) {
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

    final product = widget.product;
    final vendor = widget.vendor;
    final typeLabel =
        _typeLabels[product.type] ?? product.type.dbValue;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar ──────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: cs.surface,
              leading: Semantics(
                button: true,
                label: 'Back',
                child: GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.prostheticCatalog.path);
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
              title: ExcludeSemantics(
                child: Text(
                  'Product Detail',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              centerTitle: true,
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 1,
            ),

            // ── Content ───────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingMin,
                vertical: AppDimensions.space16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Product name (h1) ────────────────────────────────
                  Semantics(
                    header: true,
                    child: Text(
                      product.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space8),

                  // ── Type chip ────────────────────────────────────────
                  Semantics(
                    label: 'Type: $typeLabel',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space12,
                        vertical: AppDimensions.space4,
                      ),
                      decoration: BoxDecoration(
                        color: blueTint,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusChip,
                        ),
                      ),
                      child: ExcludeSemantics(
                        child: Text(
                          typeLabel,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space24),

                  // ── Details card ─────────────────────────────────────
                  _DetailCard(
                    cs: cs,
                    line: line,
                    children: [
                      if (product.material != null)
                        _DetailRow(
                          label: 'Material',
                          value: product.material!,
                          ink2: ink2,
                        ),
                      if (product.irisColor != null)
                        _DetailRow(
                          label: 'Iris colour',
                          value: product.irisColor!,
                          ink2: ink2,
                        ),
                      if (product.size != null)
                        _DetailRow(
                          label: 'Size',
                          value: product.size!,
                          ink2: ink2,
                        ),
                      _DetailRow(
                        label: 'Custom order',
                        value: product.isCustom ? 'Yes' : 'No',
                        ink2: ink2,
                      ),
                      _DetailRow(
                        label: 'Price',
                        value: _formatPrice(product.priceIdr),
                        ink2: ink2,
                        valueStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                      if (vendor != null)
                        _DetailRow(
                          label: 'Vendor',
                          value: vendor.isVerified
                              ? '${vendor.name} ✓'
                              : vendor.name,
                          ink2: ink2,
                        ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // ── Audio description card ───────────────────────────
                  Semantics(
                    label:
                        'Audio description: ${product.audioDescription}',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        AppDimensions.cardPaddingLarge,
                      ),
                      decoration: BoxDecoration(
                        color: blueTint,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusCard,
                        ),
                        border: Border.all(color: line, width: 1.5),
                      ),
                      child: ExcludeSemantics(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  size: AppDimensions.iconMd,
                                  color: cs.secondary,
                                ),
                                const SizedBox(
                                  width: AppDimensions.space8,
                                ),
                                Text(
                                  'Audio Description',
                                  style:
                                      Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: cs.secondary,
                                          ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.space8),
                            Text(
                              product.audioDescription,
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: cs.onSurface,
                                        height: 1.5,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space32),

                  // ── Order CTA ────────────────────────────────────────
                  Semantics(
                    button: true,
                    label: 'Order ${product.name}',
                    child: SizedBox(
                      width: double.infinity,
                      height: AppDimensions.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusButton,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            context.go(AppRoutes.prostheticOrders.path),
                        child: const ExcludeSemantics(
                          child: Text(
                            'Order',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SHARED DETAIL WIDGETS
// =============================================================================

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.cs,
    required this.line,
    required this.children,
  });

  final ColorScheme cs;
  final Color line;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.ink2,
    this.valueStyle,
  });

  final String label;
  final String value;
  final Color ink2;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Semantics(
      label: '$label: $value',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.space6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExcludeSemantics(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(color: ink2),
              ),
            ),
            ExcludeSemantics(
              child: Text(
                value,
                style: valueStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ERROR SCAFFOLD
// =============================================================================

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({
    required this.message,
    required this.productId,
  });

  final String message;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.prostheticCatalog.path);
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
        elevation: 0,
      ),
      body: Semantics(
        liveRegion: true,
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: cs.error),
                const SizedBox(height: AppDimensions.space16),
                Text(
                  message,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: cs.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.space24),
                Semantics(
                  button: true,
                  label: 'Retry loading product',
                  child: SizedBox(
                    height: AppDimensions.minTapTarget,
                    child: ElevatedButton(
                      onPressed: () => context
                          .read<CatalogBloc>()
                          .add(CatalogEvent.loadProduct(productId)),
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
      ),
    );
  }
}

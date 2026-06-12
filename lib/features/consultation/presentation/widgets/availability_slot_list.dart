import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';

/// Displays a list of [DoctorAvailabilityEntity] slots with booked/available
/// visual distinction.
///
/// Available slots are tappable and call [onSlotTap]; booked slots are rendered
/// in a disabled style and cannot be tapped.
class AvailabilitySlotList extends StatelessWidget {
  const AvailabilitySlotList({
    required this.slots,
    required this.onSlotTap,
    super.key,
  });

  final List<DoctorAvailabilityEntity> slots;
  final ValueChanged<DoctorAvailabilityEntity> onSlotTap;

  /// Formats a slot's date and time range.
  ///
  /// Example: "Mon, 10 Jun · 09:00–10:00"
  static String formatSlot(DoctorAvailabilityEntity slot) {
    final start = slot.slotStart.toLocal();
    final end = slot.slotEnd.toLocal();
    final datePart = DateFormat('EEE, d MMM', 'en_US').format(start);
    final startTime = DateFormat('HH:mm', 'en_US').format(start);
    final endTime = DateFormat('HH:mm', 'en_US').format(end);
    return '$datePart · $startTime–$endTime';
  }

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space32),
        child: Center(
          child: Semantics(
            label: 'No available slots',
            child: Text(
              'No available slots',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final slot in slots)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space8),
            child: _SlotRow(slot: slot, onTap: onSlotTap),
          ),
      ],
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// A single slot row tile.
class _SlotRow extends StatelessWidget {
  const _SlotRow({
    required this.slot,
    required this.onTap,
  });

  final DoctorAvailabilityEntity slot;
  final ValueChanged<DoctorAvailabilityEntity> onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final bool available = !slot.isBooked;
    final String formattedLabel = AvailabilitySlotList.formatSlot(slot);
    final String semanticsLabel =
        'Slot on $formattedLabel, ${slot.isBooked ? 'already booked' : 'available, tap to book'}';

    final Color bgColor = available
        ? (ext?.blueTint ?? cs.primaryContainer)
        : (ext?.line ?? cs.outline).withValues(alpha: 0.35);

    final Color textColor =
        available ? cs.primary : (ext?.ink3 ?? cs.onSurfaceVariant);

    final Widget rowContent = Container(
      constraints: const BoxConstraints(minHeight: AppDimensions.minTapTarget),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.space12,
        horizontal: AppDimensions.space16,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
        border: Border.all(
          color: available
              ? cs.primary.withValues(alpha: 0.25)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                formattedLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
          if (slot.isBooked)
            ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.space4,
                  horizontal: AppDimensions.space8,
                ),
                decoration: BoxDecoration(
                  color: (ext?.ink3 ?? cs.onSurfaceVariant)
                      .withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusChip),
                ),
                child: Text(
                  'Booked',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ext?.ink3 ?? cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Semantics(
      button: available,
      label: semanticsLabel,
      child: available
          ? GestureDetector(
              onTap: () => onTap(slot),
              child: rowContent,
            )
          : rowContent,
    );
  }
}

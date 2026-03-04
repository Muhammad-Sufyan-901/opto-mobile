import 'package:flutter/material.dart';

// ==========================================
// SELECT GROUP & ITEM MODEL
// ==========================================
class AppSelectGroup<T> {
  final String label;
  final List<AppSelectItem<T>> items;
  const AppSelectGroup({
    required this.label,
    required this.items,
  });
}

class AppSelectItem<T> {
  final T value;
  final String label;
  final Widget? customChild;
  const AppSelectItem({
    required this.value,
    required this.label,
    this.customChild,
  });
}

const double _defaultRadius = 16.0;
const double _defaultMaxHeight = 300.0;
const double _defaultPrefixIconSize = 20.0;

// ==========================================
// MAIN SELECT WIDGET
// ==========================================
class AppSelectField<T> extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final T? value;

  // Separate items and grouped items
  final List<AppSelectItem<T>>? items;
  final List<AppSelectGroup<T>>? groupedItems;

  final void Function(T?)? onChanged;

  final bool isRequired;
  final double radius;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final double prefixIconSize;
  final String? Function(T?)? validator;

  final bool disabled;
  final double maxHeight;

  const AppSelectField({
    super.key,
    this.items,
    this.groupedItems,
    this.value,
    this.onChanged,
    this.label,
    this.hintText,
    this.helperText,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.validator,
    this.disabled = false,
    this.maxHeight = _defaultMaxHeight,
  }) : assert(
         items != null || groupedItems != null,
         'Must provide either items or groupedItems',
       );

  @override
  State<AppSelectField<T>> createState() => _AppSelectFieldState<T>();
}

class _AppSelectFieldState<T> extends State<AppSelectField<T>> {
  final MenuController _menuController = MenuController();
  late FocusNode _focusNode;
  bool _isFocused = false;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    _textController = TextEditingController(
      text: _getSelectedLabel(widget.value),
    );
  }

  @override
  void didUpdateWidget(AppSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newText = _getSelectedLabel(widget.value);
      if (_textController.text != newText) {
        _textController.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  String _getSelectedLabel(T? value) {
    if (value == null) return '';

    if (widget.items != null) {
      for (var item in widget.items!) {
        if (item.value == value) return item.label;
      }
    }

    if (widget.groupedItems != null) {
      for (var group in widget.groupedItems!) {
        for (var item in group.items) {
          if (item.value == value) return item.label;
        }
      }
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color defaultGrey = Colors.grey.shade500;
    final Color baseBorderColor = isDarkMode
        ? colorScheme.outlineVariant
        : defaultGrey;

    final bool effectivelyDisabled =
        widget.disabled || widget.onChanged == null;

    Color resolvedFillColor = colorScheme.surface;
    if (effectivelyDisabled) {
      resolvedFillColor = colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.5,
      );
    } else if (isDarkMode) {
      resolvedFillColor = colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.2,
      );
    }

    Widget? resolvedPrefixIcon;
    if (widget.prefixIcon != null) {
      resolvedPrefixIcon = Icon(
        widget.prefixIcon,
        color: widget.prefixIconColor ?? defaultGrey,
        size: widget.prefixIconSize,
      );
    }

    String? Function(String?)? resolvedValidator;
    if (widget.isRequired || widget.validator != null) {
      resolvedValidator = (_) {
        if (widget.isRequired && _textController.text.isEmpty) {
          final cleanLabel = widget.label?.replaceAll('*', '').trim();
          return '${cleanLabel ?? 'Kolom ini'} wajib dipilih';
        }
        if (widget.validator != null) return widget.validator!(widget.value);
        return null;
      };
    }

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: baseBorderColor,
        width: 1.5,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 2,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1.5,
      ),
    );

    // ➔ ✨ REFACTOR: BoxShadow Complex Ternary
    List<BoxShadow>? resolvedBoxShadow;
    if (_isFocused && !effectivelyDisabled) {
      resolvedBoxShadow = [
        BoxShadow(
          color: colorScheme.primary.withValues(
            alpha: 0.25,
          ),
          blurRadius: 0,
          spreadRadius: 4,
          offset: const Offset(0, 0),
        ),
      ];
    }

    final MenuStyle dropdownMenuStyle = MenuStyle(
      backgroundColor: WidgetStateProperty.all(colorScheme.surface),
      surfaceTintColor: WidgetStateProperty.all(colorScheme.surface),
      side: WidgetStateProperty.all(
        BorderSide(
          color: baseBorderColor,
          width: 1.5,
        ),
      ),
      elevation: const WidgetStatePropertyAll(6),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: 8,
        ),
      ),
      maximumSize: WidgetStatePropertyAll(
        Size.fromHeight(widget.maxHeight),
      ),
    );

    Widget buildMenuItem(AppSelectItem<T> item, double width) {
      final bool isSelected = widget.value == item.value;

      VoidCallback? handleItemPress;
      if (!effectivelyDisabled) {
        handleItemPress = () {
          if (widget.onChanged != null) widget.onChanged!(item.value);
          _menuController.close();
        };
      }

      return Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: MenuItemButton(
          onPressed: handleItemPress,
          style: MenuItemButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:
                    item.customChild ??
                    Text(
                      item.label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: colorScheme.onSurface,
                ),
            ],
          ),
        ),
      );
    }

    List<Widget> buildMenuChildren(BoxConstraints constraints) {
      List<Widget> children = [];
      if (widget.items != null) {
        for (var item in widget.items!) {
          children.add(buildMenuItem(item, constraints.maxWidth));
        }
      } else if (widget.groupedItems != null) {
        for (int index = 0; index < widget.groupedItems!.length; index++) {
          final group = widget.groupedItems![index];
          children.add(
            Container(
              width: constraints.maxWidth,
              padding: const EdgeInsets.only(
                left: 20,
                right: 16,
                top: 8,
                bottom: 4,
              ),
              child: Text(
                group.label,
                style: textTheme.labelSmall?.copyWith(
                  color: defaultGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
          for (var item in group.items) {
            children.add(buildMenuItem(item, constraints.maxWidth));
          }
          if (index < widget.groupedItems!.length - 1) {
            children.add(
              Divider(
                color: baseBorderColor,
                height: 16,
                indent: 8,
                endIndent: 8,
              ),
            );
          }
        }
      }
      return children;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: effectivelyDisabled
                    ? defaultGrey
                    : colorScheme.onSurface,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        Container(
          decoration: BoxDecoration(
            color: resolvedFillColor,
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: resolvedBoxShadow,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return MenuAnchor(
                controller: _menuController,
                style: dropdownMenuStyle,
                alignmentOffset: const Offset(0, 8),
                menuChildren: buildMenuChildren(constraints),
                builder:
                    (
                      BuildContext context,
                      MenuController controller,
                      Widget? child,
                    ) {
                      VoidCallback? handleInputTap;
                      if (!effectivelyDisabled) {
                        handleInputTap = () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        };
                      }

                      return TextFormField(
                        controller: _textController,
                        focusNode: _focusNode,
                        readOnly: true,
                        enabled: !effectivelyDisabled,
                        onTap: handleInputTap,
                        validator: resolvedValidator,
                        style: textTheme.bodyLarge?.copyWith(
                          color: effectivelyDisabled
                              ? defaultGrey
                              : colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            color: defaultGrey,
                          ),
                          prefixIcon: resolvedPrefixIcon,
                          suffixIcon: AnimatedRotation(
                            turns: controller.isOpen ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: effectivelyDisabled
                                  ? defaultGrey.withValues(
                                      alpha: 0.5,
                                    )
                                  : defaultGrey,
                              size: 20,
                            ),
                          ),
                          enabledBorder: inputBorder,
                          focusedBorder: focusedBorder,
                          errorBorder: errorBorder,
                          focusedErrorBorder: errorBorder,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(widget.radius),
                            borderSide: BorderSide(
                              color: defaultGrey.withValues(
                                alpha: 0.5,
                              ),
                              width: 1.0,
                            ),
                          ),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      );
                    },
              );
            },
          ),
        ),

        if (widget.helperText != null) ...[
          const SizedBox(
            height: 6,
          ),
          Text(
            widget.helperText!,
            style: textTheme.labelSmall?.copyWith(color: defaultGrey),
          ),
        ],
      ],
    );
  }
}

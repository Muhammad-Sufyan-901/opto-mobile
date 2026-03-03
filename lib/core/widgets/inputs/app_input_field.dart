import 'package:flutter/material.dart';
import 'package:ids_elder_rehab_app/core/utils/input_validator.dart';

enum AppInputFieldType {
  text,
  email,
  password,
  number,
  date,
  textArea,
}

const double _defaultRadius = 16.0;
const double _defaultSuffixIconSize = 20.0;
const double _defaultPrefixIconSize = 20.0;

class AppInputField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final TextEditingController? controller;
  final AppInputFieldType type;
  final bool readOnly;
  final bool disabled;
  final bool isRequired;
  final double radius;
  final Color? suffixIconColor;
  final double suffixIconSize;
  final Color? prefixIconColor;
  final double prefixIconSize;
  final TextStyle? hintTextStyle;
  final TextStyle? helperTextStyle;
  final Color? hintTextColor;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int maxLines;
  final TextInputAction? textInputAction;

  // ==========================================
  // NAMED CONSTRUCTORS (Input Field Factory)
  // ==========================================
  const AppInputField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.helperTextStyle,
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction,
  }) : type = AppInputFieldType.text;

  const AppInputField.email({
    super.key,
    this.label,
    this.hintText = 'contoh@email.com',
    this.helperText,
    this.controller,
    this.validator,
    this.prefixIcon = Icons.email_outlined,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.helperTextStyle,
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  }) : type = AppInputFieldType.email;

  const AppInputField.password({
    super.key,
    this.label,
    this.hintText = 'Kata Sandi',
    this.helperText,
    this.controller,
    this.validator,
    this.prefixIcon = Icons.lock_outline,
    this.onTap,
    this.readOnly = false,
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.helperTextStyle,
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
  }) : type = AppInputFieldType.password,
       suffixIcon = null;

  const AppInputField.number({
    super.key,
    this.label,
    this.hintText = '0123456789',
    this.helperText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.helperTextStyle,
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  }) : type = AppInputFieldType.number;

  const AppInputField.date({
    super.key,
    this.label,
    this.hintText = 'Pilih tanggal',
    this.helperText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon = Icons.calendar_today_outlined,
    this.onTap,
    this.readOnly = true,
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.helperTextStyle,
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction,
  }) : type = AppInputFieldType.date;

  const AppInputField.textArea({
    super.key,
    this.label,
    this.hintText = 'Tuliskan catatan...',
    this.helperText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.helperTextStyle,
    this.hintTextColor,
    this.maxLines = 5,
    this.textInputAction = TextInputAction.newline,
  }) : type = AppInputFieldType.textArea;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _isObscured = true;

  // FOCUS NODE
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleInputTapped() async {
    // Interceptor to handle date input
    if (widget.type == AppInputFieldType.date) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      // If date is picked, format it and set it to the controller
      if (picked != null && widget.controller != null) {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year.toString();

        widget.controller!.text = "$day/$month/$year";
      }
    }

    // Call the onTap callback if provided
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color defaultGrey500 = Colors.grey.shade500;
    final Color defaultGrey600 = Colors.grey.shade600;

    final Color baseBorderColor = isDarkMode
        ? colorScheme.outlineVariant
        : defaultGrey500;

    // Fill color: Dark mode provides a dark grey fill. Light mode stays transparent (surface) except when readOnly or disabled.
    Color resolvedFillColor = colorScheme.surface;
    if (widget.disabled || widget.readOnly) {
      resolvedFillColor = colorScheme.surfaceContainerHighest;
    } else if (isDarkMode) {
      // Shadcn dark mode input has background fill
      resolvedFillColor = colorScheme.surfaceContainer;
    }

    // Icon and text color resolution
    final Color resolvedHintColor = widget.hintTextColor ?? defaultGrey600;
    final Color resolvedPrefixColor = widget.prefixIconColor ?? defaultGrey600;
    final Color resolvedSuffixColor = widget.suffixIconColor ?? defaultGrey600;

    // ==========================================
    // RESOLUTION LOGIC
    // ==========================================
    bool resolvedObscureText = false;
    TextInputType resolvedKeyboardType = TextInputType.text;
    Widget? resolvedSuffixIcon;
    Widget? resolvedPrefixIcon;

    // 1. Keyboard Type
    if (widget.type == AppInputFieldType.email) {
      resolvedKeyboardType = TextInputType.emailAddress;
    } else if (widget.type == AppInputFieldType.number) {
      resolvedKeyboardType = TextInputType.number;
    } else if (widget.type == AppInputFieldType.password) {
      resolvedObscureText = _isObscured;
      resolvedKeyboardType = TextInputType.visiblePassword;
    } else if (widget.type == AppInputFieldType.date) {
      resolvedKeyboardType = TextInputType.datetime;
    } else if (widget.type == AppInputFieldType.textArea) {
      resolvedKeyboardType = TextInputType.multiline;
    }

    // 2. Right Icon
    if (widget.type == AppInputFieldType.password) {
      IconData eyeIcon = _isObscured
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined;
      resolvedSuffixIcon = IconButton(
        icon: Icon(
          eyeIcon,
          color: resolvedSuffixColor,
          size: widget.suffixIconSize,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      resolvedSuffixIcon = Icon(
        widget.suffixIcon,
        color: resolvedSuffixColor,
        size: widget.suffixIconSize,
      );
    }

    // 3. Left Icon
    if (widget.prefixIcon != null) {
      resolvedPrefixIcon = Icon(
        widget.prefixIcon,
        color: resolvedPrefixColor,
        size: widget.prefixIconSize,
      );
    }

    // ==========================================
    // BORDER STYLING
    // ==========================================
    final InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: baseBorderColor,
        width: 1.5,
      ),
    );

    final InputBorder disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: baseBorderColor.withValues(
          alpha: 0.5,
        ),
        width: 1.5,
      ),
    );

    final InputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 2.0,
      ),
    );

    final InputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1.5,
      ),
    );

    // ==========================================
    // VALIDATOR RESOLUTION
    // ==========================================
    String? Function(String?)? resolvedValidator;

    if (widget.isRequired || widget.validator != null) {
      resolvedValidator = (String? value) {
        if (widget.isRequired) {
          final String? cleanLabel = widget.label?.replaceAll('*', '').trim();
          final String? requiredError = InputValidator.required(
            value,
            fieldName: cleanLabel,
          );

          if (requiredError != null) {
            return requiredError;
          }
        }

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        return null;
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // LABEL WITH ASTERISK
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.disabled ? defaultGrey500 : colorScheme.onSurface,
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
          const SizedBox(
            height: 8,
          ),
        ],

        // INPUT BOX (SOLID FOCUS RING)
        Container(
          decoration: BoxDecoration(
            color: resolvedFillColor,
            // Add 4px to the radius to create space for the focus ring
            borderRadius: BorderRadius.circular(widget.radius + 4),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 0,
                      spreadRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: !widget.disabled,
            obscureText: resolvedObscureText,
            keyboardType: resolvedKeyboardType,
            readOnly: widget.readOnly,
            onTap: _handleInputTapped,
            validator: resolvedValidator,
            maxLines: widget.maxLines,
            textInputAction: widget.textInputAction,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: textTheme.bodyLarge
                  ?.copyWith(
                    color: resolvedHintColor,
                  )
                  .merge(widget.hintTextStyle),
              prefixIcon: resolvedPrefixIcon,
              suffixIcon: resolvedSuffixIcon,

              enabledBorder: inputBorder,
              disabledBorder: disabledBorder,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,

              filled: true,
              fillColor: resolvedFillColor,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        // HELPER TEXT
        if (widget.helperText != null) ...[
          const SizedBox(
            height: 6,
          ),
          Text(
            widget.helperText!,
            style: textTheme.labelSmall
                ?.copyWith(
                  color: defaultGrey600,
                )
                .merge(widget.helperTextStyle),
          ),
        ],
      ],
    );
  }
}

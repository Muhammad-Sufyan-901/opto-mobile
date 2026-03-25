import 'dart:io';
import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/utils/input_validator.dart';

enum AppInputFieldType {
  text,
  email,
  password,
  number,
  date,
  textArea,
  file,
}

const double _defaultRadius = 16.0;
const double _defaultSuffixIconSize = 20.0;
const double _defaultPrefixIconSize = 20.0;

class AppInputField extends StatefulWidget {
  final String? hintText;
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
    this.hintText,
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
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction,
  }) : type = AppInputFieldType.text;

  const AppInputField.email({
    super.key,
    this.hintText = 'contoh@email.com',
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
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  }) : type = AppInputFieldType.email;

  const AppInputField.password({
    super.key,
    this.hintText = 'Kata Sandi',
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
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
  }) : type = AppInputFieldType.password,
       suffixIcon = null;

  const AppInputField.number({
    super.key,
    this.hintText = '0123456789',
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
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  }) : type = AppInputFieldType.number;

  const AppInputField.date({
    super.key,
    this.hintText = 'Pilih tanggal',
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
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction,
  }) : type = AppInputFieldType.date;

  const AppInputField.textArea({
    super.key,
    this.hintText = 'Tuliskan catatan...',
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
    this.hintTextColor,
    this.maxLines = 5,
    this.textInputAction = TextInputAction.newline,
  }) : type = AppInputFieldType.textArea;

  const AppInputField.file({
    super.key,
    this.hintText = 'Pilih atau unggah file...',
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon = Icons.upload_file_outlined,
    this.onTap,
    this.readOnly = true, // Always readOnly to enable tap
    this.disabled = false,
    this.isRequired = false,
    this.radius = _defaultRadius,
    this.suffixIconColor,
    this.suffixIconSize = _defaultSuffixIconSize,
    this.prefixIconColor,
    this.prefixIconSize = _defaultPrefixIconSize,
    this.hintTextStyle,
    this.hintTextColor,
    this.maxLines = 1,
    this.textInputAction,
  }) : type = AppInputFieldType.file;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _isObscured = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  late TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    _displayController = TextEditingController();

    if (widget.type == AppInputFieldType.file && widget.controller != null) {
      _syncDisplayController();
      widget.controller!.addListener(_syncDisplayController);
    }
  }

  void _syncDisplayController() {
    if (widget.controller == null) return;

    final String fullPath = widget.controller!.text;
    final String fileName = fullPath.isEmpty
        ? ''
        : fullPath.split('/').last.split('\\').last;

    if (_displayController.text != fileName) {
      _displayController.text = fileName;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (widget.type == AppInputFieldType.file && widget.controller != null) {
      widget.controller!.removeListener(_syncDisplayController);
    }
    _displayController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleInputTapped() async {
    if (widget.disabled) return;

    if (widget.type == AppInputFieldType.date) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (picked != null && widget.controller != null) {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year.toString();
        widget.controller!.text = "$day/$month/$year";
      }
    } else if (widget.type == AppInputFieldType.file) {
      FocusScope.of(context).unfocus();
    }

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

    Color resolvedFillColor = colorScheme.surface;
    if (widget.disabled ||
        widget.readOnly && widget.type != AppInputFieldType.file) {
      resolvedFillColor = colorScheme.surfaceContainerHighest;
    } else if (isDarkMode) {
      resolvedFillColor = colorScheme.surfaceContainer;
    }

    final Color resolvedHintColor = widget.hintTextColor ?? defaultGrey600;
    final Color resolvedPrefixColor = widget.prefixIconColor ?? defaultGrey600;
    final Color resolvedSuffixColor = widget.suffixIconColor ?? defaultGrey600;

    bool resolvedObscureText = false;
    TextInputType resolvedKeyboardType = TextInputType.text;
    Widget? resolvedSuffixIcon;
    Widget? resolvedPrefixIcon;

    if (widget.type == AppInputFieldType.email) {
      resolvedKeyboardType = TextInputType.emailAddress;
    } else if (widget.type == AppInputFieldType.number) {
      resolvedKeyboardType = TextInputType.number;
    } else if (widget.type == AppInputFieldType.password) {
      resolvedObscureText = _isObscured;
      resolvedKeyboardType = TextInputType.visiblePassword;
    } else if (widget.type == AppInputFieldType.date ||
        widget.type == AppInputFieldType.file) {
      resolvedKeyboardType = TextInputType.none;
    } else if (widget.type == AppInputFieldType.textArea) {
      resolvedKeyboardType = TextInputType.multiline;
    }

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

    if (widget.prefixIcon != null) {
      resolvedPrefixIcon = Icon(
        widget.prefixIcon,
        color: resolvedPrefixColor,
        size: widget.prefixIconSize,
      );
    }

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
        color: baseBorderColor.withValues(alpha: 0.5),
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
    // ➔ ✨ INTERSEPTOR VALIDATOR
    // ==========================================
    String? Function(String?)? resolvedValidator;
    if (widget.isRequired || widget.validator != null) {
      resolvedValidator = (String? value) {
        final String? valueToValidate = widget.type == AppInputFieldType.file
            ? widget.controller?.text
            : value;

        if (widget.isRequired) {
          // FieldName tidak dikirim agar menggunakan pesan default dari validator
          final String? requiredError = InputValidator.required(
            valueToValidate,
          );
          if (requiredError != null) return requiredError;
        }
        if (widget.validator != null) return widget.validator!(valueToValidate);
        return null;
      };
    }

    Widget? filePreviewWidget;
    if (widget.type == AppInputFieldType.file &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      final String filePath = widget.controller!.text;
      final String extension = filePath.split('.').last.toLowerCase();

      final bool isImage = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
      ].contains(extension);
      final bool isVideo = ['mp4', 'mov', 'avi', 'mkv'].contains(extension);

      try {
        final File targetFile = File(filePath);
        if (targetFile.existsSync()) {
          if (isImage) {
            filePreviewWidget = Container(
              margin: const EdgeInsets.only(top: 12),
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                border: Border.all(color: baseBorderColor),
                image: DecorationImage(
                  image: FileImage(targetFile),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else if (isVideo) {
            filePreviewWidget = Container(
              margin: const EdgeInsets.only(top: 12),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                border: Border.all(color: baseBorderColor),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_camera_back_outlined,
                      size: 40,
                      color: defaultGrey600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Video siap diunggah',
                      style: textTheme.labelMedium?.copyWith(
                        color: defaultGrey600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      } catch (_) {}
    }

    // UI KINI HANYA BERFOKUS PADA KOTAK INPUT
    Widget inputWidget = Container(
      decoration: BoxDecoration(
        color: resolvedFillColor,
        borderRadius: BorderRadius.circular(widget.radius + 4),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 0,
                  spreadRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.type == AppInputFieldType.file
            ? _displayController
            : widget.controller,
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
              ?.copyWith(color: resolvedHintColor)
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
    );

    // Jika ada file preview, bungkus dengan Column, jika tidak, langsung return kotaknya!
    if (filePreviewWidget != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          inputWidget,
          filePreviewWidget,
        ],
      );
    }

    return inputWidget;
  }
}

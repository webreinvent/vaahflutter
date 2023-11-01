import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_theme.dart';
import '../../helpers/constants.dart';
import '../../helpers/enums.dart';

class InputText extends StatelessWidget {
  final String? label;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isEnabled;
  final InputSize size;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Function()? prefixOnTap;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final Function()? suffixOnTap;
  final int? minLines;
  final int? maxLines;
  final InputBorderType inputBorder;

  const InputText({
    super.key,
    this.label,
    this.padding = allPadding12,
    this.borderRadius = defaultPadding / 2,
    this.isEnabled = true,
    this.size = InputSize.medium,
    this.controller,
    this.onChanged,
    this.autoValidateMode,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixOnTap,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixOnTap,
    this.minLines,
    this.maxLines,
    this.inputBorder = InputBorderType.outline,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: padding,
        border: getInputBorder(inputBorder, AppTheme.colors['black']!.shade400),
        enabledBorder: getInputBorder(inputBorder, AppTheme.colors['black']!.shade400),
        disabledBorder: getInputBorder(inputBorder, AppTheme.colors['black']!.shade300),
        focusedBorder: getInputBorder(inputBorder, AppTheme.colors['black']!.shade400),
        errorBorder: getInputBorder(inputBorder, AppTheme.colors['danger']!.shade400),
        focusedErrorBorder: getInputBorder(inputBorder, AppTheme.colors['danger']!.shade400),
        errorStyle: TextStyle(color: AppTheme.colors['danger']!.shade400),
        hintText: label,
        hintStyle: TextStyle(
          fontSize: getFontSize(),
          color:
              isEnabled ? AppTheme.colors['black']!.shade400 : AppTheme.colors['black']!.shade300,
        ),
        prefixIcon: prefixIcon != null
            ? InkWell(
                onTap: prefixOnTap,
                child: Center(
                  child: Container(
                    margin: horizontalPadding4,
                    child: FaIcon(
                      prefixIcon,
                      size: getFontSize() * 1.15,
                      color: prefixIconColor ?? AppTheme.colors['black']!.shade400,
                    ),
                  ),
                ),
              )
            : null,
        prefixIconConstraints: BoxConstraints(
          maxWidth: getFontSize() * 2.3,
          maxHeight: getFontSize() * 2.3,
        ),
        suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: suffixOnTap,
                child: Center(
                  child: Container(
                    margin: horizontalPadding4,
                    child: FaIcon(
                      suffixIcon,
                      size: getFontSize() * 1.15,
                      color: suffixIconColor ?? AppTheme.colors['black']!.shade400,
                    ),
                  ),
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          maxWidth: getFontSize() * 2.3,
          maxHeight: getFontSize() * 2.3,
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: getFontSize(),
        color: AppTheme.colors['black']!.shade400,
      ),
      enabled: isEnabled,
      autovalidateMode: autoValidateMode,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  InputBorder getInputBorder(InputBorderType inputBorderType, Color color) {
    switch (inputBorderType) {
      case InputBorderType.none:
        return InputBorder.none;

      case InputBorderType.underline:
        return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: color,
          ),
        );

      case InputBorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: color,
          ),
        );
    }
  }

  double getFontSize() {
    switch (size) {
      case InputSize.extraSmall:
        return AppTheme.extraSmall;
      case InputSize.small:
        return AppTheme.small;
      case InputSize.large:
        return AppTheme.large;
      case InputSize.extraLarge:
        return AppTheme.extraLarge;
      default:
        return AppTheme.medium;
    }
  }
}

enum InputBorderType {
  underline,
  outline,
  none,
}

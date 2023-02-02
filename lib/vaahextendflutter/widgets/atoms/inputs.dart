import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';

enum InputSize { extraSmall, small, medium, large, extraLarge }

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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: padding,
        border: border(AppTheme.colors['black']!.shade400),
        enabledBorder: border(AppTheme.colors['black']!.shade400),
        disabledBorder: border(AppTheme.colors['black']!.shade300),
        focusedBorder: border(AppTheme.colors['black']!.shade400),
        errorBorder: border(AppTheme.colors['danger']!.shade400),
        focusedErrorBorder: border(AppTheme.colors['danger']!.shade400),
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

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        width: 1,
        color: color,
      ),
    );
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

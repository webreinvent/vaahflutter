import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_theme.dart';
import '../../helpers/constants.dart';
import '../../helpers/enums.dart';

typedef OnPressed = void Function()?;

Color? getColorForButtonType(ButtonType type) {
  switch (type) {
    case ButtonType.primary:
      return AppTheme.colors['primary'];
    case ButtonType.secondary:
      return AppTheme.colors['secondary'];
    case ButtonType.info:
      return AppTheme.colors['info'];
    case ButtonType.success:
      return AppTheme.colors['success'];
    case ButtonType.danger:
      return AppTheme.colors['danger'];
    case ButtonType.warning:
      return AppTheme.colors['warning'];
    case ButtonType.help:
      return AppTheme.colors['help'];
    default:
      return null;
  }
}

class ButtonElevated extends StatelessWidget {
  final OnPressed onPressed;
  final String text;
  final ButtonStyle? style;
  final ButtonType? buttonType;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonElevated({
    Key? key,
    required this.onPressed,
    required this.text,
    this.style,
    this.buttonType,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // assert(!(buttonType != null && backgroundColor != null));
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? (buttonType == null ? null : getColorForButtonType(buttonType!)),
            foregroundColor: foregroundColor,
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
            padding: padding,
          ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class ButtonElevatedWithIcon extends StatelessWidget {
  final OnPressed onPressed;
  final String text;
  final Widget? leading;
  final ButtonStyle? style;
  final ButtonType? buttonType;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonElevatedWithIcon({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.leading,
    this.style,
    this.buttonType,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.iconSize = 16,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? (buttonType == null ? null : getColorForButtonType(buttonType!)),
            foregroundColor: foregroundColor,
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
            padding: padding,
          ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      icon: leading!,
    );
  }
}

class ButtonOutlined extends StatelessWidget {
  final OnPressed onPressed;
  final String text;
  final ButtonStyle? style;
  final ButtonType? buttonType;
  final Color? foregroundColor;
  final double? fontSize;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonOutlined({
    Key? key,
    required this.onPressed,
    required this.text,
    this.style,
    this.buttonType,
    this.foregroundColor,
    this.fontSize,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: style ??
          OutlinedButton.styleFrom(
            side: BorderSide(
              width: 2.0,
              color: foregroundColor ?? getColorForButtonType(buttonType ?? ButtonType.primary)!,
            ),
            foregroundColor:
                foregroundColor ?? (buttonType == null ? null : getColorForButtonType(buttonType!)),
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
            padding: padding,
          ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class ButtonOutlinedWithIcon extends StatelessWidget {
  final OnPressed onPressed;
  final String text;
  final IconData? iconData;
  final ButtonStyle? style;
  final ButtonType? buttonType;
  final Color? foregroundColor;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonOutlinedWithIcon({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.iconData,
    this.style,
    this.buttonType,
    this.foregroundColor,
    this.fontSize,
    this.iconSize = 16,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: style ??
          OutlinedButton.styleFrom(
            side: BorderSide(
              width: 2.0,
              color: foregroundColor ?? getColorForButtonType(buttonType ?? ButtonType.primary)!,
            ),
            foregroundColor:
                foregroundColor ?? (buttonType == null ? null : getColorForButtonType(buttonType!)),
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
            padding: padding,
          ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      icon: FaIcon(
        iconData,
        size: iconSize,
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final OnPressed onPressed;
  final String text;
  final ButtonStyle? style;
  final ButtonType? buttonType;
  final Color? foregroundColor;
  final double? fontSize;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonText({
    Key? key,
    required this.onPressed,
    required this.text,
    this.style,
    this.buttonType,
    this.foregroundColor,
    this.fontSize,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: style ??
          TextButton.styleFrom(
            foregroundColor:
                foregroundColor ?? (buttonType == null ? null : getColorForButtonType(buttonType!)),
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
            padding: padding,
          ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class ButtonTextWithIcon extends StatelessWidget {
  final OnPressed onPressed;
  final String text;
  final Widget leading;
  final ButtonStyle? style;
  final ButtonType? buttonType;
  final Color? foregroundColor;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonTextWithIcon({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.leading,
    this.style,
    this.buttonType,
    this.foregroundColor,
    this.fontSize,
    this.iconSize = 16,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: style ??
          TextButton.styleFrom(
            foregroundColor:
                foregroundColor ?? (buttonType == null ? null : getColorForButtonType(buttonType!)),
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
            padding: padding,
          ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      icon: leading,
    );
  }
}

class ButtonIcon extends StatelessWidget {
  final OnPressed onPressed;
  final IconData? iconData;
  final ButtonType? buttonType;
  final Color? color;
  final double? iconSize;
  final bool enableBorder;
  final double? borderRadius;
  final EdgeInsets? padding;

  const ButtonIcon({
    Key? key,
    required this.onPressed,
    required this.iconData,
    this.buttonType,
    this.color,
    this.iconSize = 20,
    this.enableBorder = true,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          border: !enableBorder
              ? null
              : Border.all(
                  width: 2.0,
                  color: color ?? getColorForButtonType(buttonType ?? ButtonType.primary)!,
                ),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius ?? 1000.0),
          onTap: onPressed,
          child: Padding(
            padding: padding ?? allPadding8,
            child: FaIcon(
              iconData,
              size: iconSize,
              color: color ?? getColorForButtonType(buttonType ?? ButtonType.primary),
            ),
          ),
        ),
      ),
    );
  }
}

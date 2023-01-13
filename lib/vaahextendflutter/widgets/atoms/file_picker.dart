import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';

enum InputSize { extraSmall, small, medium, large, extraLarge }

class FilePicker extends StatefulWidget {
  final String label;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isEnabled;
  final InputSize size;
  final double height;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;
  final Function(dynamic)? onSelected;

  const FilePicker({
    super.key,
    required this.label,
    this.padding = allPadding12,
    this.borderRadius = defaultPadding / 2,
    this.isEnabled = true,
    this.size = InputSize.medium,
    this.height = 250,
    this.iconBackgroundColor,
    this.iconColor,
    this.validator,
    this.autoValidateMode,
    this.onSelected,
  });

  @override
  State<FilePicker> createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      decoration: InputDecoration(
        contentPadding: widget.padding,
        border: border(AppTheme.colors['black']!.shade400),
        enabledBorder: border(AppTheme.colors['black']!.shade400),
        disabledBorder: border(AppTheme.colors['black']!.shade300),
        focusedBorder: border(AppTheme.colors['black']!.shade400),
        errorBorder: border(AppTheme.colors['danger']!.shade400),
        focusedErrorBorder: border(AppTheme.colors['danger']!.shade400),
        errorStyle: TextStyle(color: AppTheme.colors['danger']!.shade400),
        hintText: widget.label,
        hintStyle: TextStyle(
          fontSize: getFontSize(),
          color: widget.isEnabled
              ? AppTheme.colors['black']!.shade400
              : AppTheme.colors['black']!.shade300,
        ),
        suffixIcon: InkWell(
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius),
              ),
              color: widget.iconBackgroundColor ?? AppTheme.colors['primary'],
            ),
            child: SvgPicture.asset(
              asset(),
              height: getFontSize() * 1.2,
              color: widget.iconColor ?? AppTheme.colors['white'],
            ),
          ),
        ),
      ),
      readOnly: true,
      style: TextStyle(
        fontSize: getFontSize(),
        color: AppTheme.colors['black']!.shade400,
      ),
      enabled: widget.isEnabled,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
    );
  }

  void onTap() async {
    fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles();

    if (result != null) {
      fp.PlatformFile file = result.files.first;

      debugPrint(file.name);
      debugPrint(file.bytes.toString());
      debugPrint(file.size.toString());
      debugPrint(file.extension);
      debugPrint(file.path);
    } else {
      // User canceled the picker
    }
  }

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        width: 1,
        color: color,
      ),
    );
  }

  double getFontSize() {
    switch (widget.size) {
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

  String asset() {
    return 'assets/icons/general/icon_file.svg';
  }
}

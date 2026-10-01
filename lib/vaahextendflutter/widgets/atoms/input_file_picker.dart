import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_theme.dart';
import '../../helpers/constants.dart';
import '../../helpers/enums.dart';

class InputFilePicker extends StatefulWidget {
  final String label;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isEnabled;
  final InputSize size;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;
  final Function(List<PlatformFile>?)? callback;
  final String? dialogTitle;
  /// Retained for API compatibility. file_picker >= 11 removed the `withData`
  /// pick option; bytes are now read on demand via `PlatformFile.readAsBytes()`,
  /// so this flag no longer changes behavior.
  final bool withData;
  final bool allowMultiple;
  final FileType fileType;
  final List<String>? allowedExtensions;

  const InputFilePicker({
    super.key,
    required this.label,
    this.padding = allPadding12,
    this.borderRadius = defaultPadding / 2,
    this.isEnabled = true,
    this.size = InputSize.medium,
    this.iconBackgroundColor,
    this.iconColor,
    this.validator,
    this.autoValidateMode,
    this.callback,
    this.dialogTitle,
    this.withData = false,
    this.allowMultiple = false,
    this.fileType = FileType.any,
    this.allowedExtensions,
  });

  @override
  State<InputFilePicker> createState() => _InputFilePickerState();
}

class _InputFilePickerState extends State<InputFilePicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: _onTap,
      decoration: InputDecoration(
        contentPadding: widget.padding,
        border: border(AppTheme.colors['black']!.shade400),
        enabledBorder: border(AppTheme.colors['black']!.shade400),
        disabledBorder: border(AppTheme.colors['black']!.shade300),
        focusedBorder: border(AppTheme.colors['black']!.shade400),
        errorBorder: border(AppTheme.colors['danger']!.shade400),
        focusedErrorBorder: border(AppTheme.colors['danger']!.shade400),
        errorStyle: TextStyle(color: AppTheme.colors['danger']!.shade400),
        suffixIcon: InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius),
              ),
              color: widget.iconBackgroundColor ?? AppTheme.colors['primary'],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  asset(),
                  size: getFontSize() * 1.3,
                  color: widget.iconColor ?? AppTheme.colors['white'],
                ),
              ],
            ),
          ),
        ),
      ),
      controller: _controller,
      readOnly: true,
      style: TextStyle(
        fontSize: getFontSize(),
        color: widget.isEnabled
            ? AppTheme.colors['black']!.shade400
            : AppTheme.colors['black']!.shade300,
      ),
      enabled: widget.isEnabled,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
    );
  }

  void _onTap() async {
    // file_picker >= 11: `FilePicker` is now a static class (no `.platform`),
    // and `pickFiles`/`pickFile` return the files directly instead of a
    // `FilePickerResult`. `allowMultiple` and `withData` were removed: single vs.
    // multi is now `pickFile` vs. `pickFiles`, and bytes are read on demand via
    // `PlatformFile.readAsBytes()`.
    final List<PlatformFile> files;
    if (widget.allowMultiple) {
      files = await FilePicker.pickFiles(
        allowedExtensions: widget.allowedExtensions,
        dialogTitle: widget.dialogTitle,
        type: widget.fileType,
      );
    } else {
      final PlatformFile? file = await FilePicker.pickFile(
        allowedExtensions: widget.allowedExtensions,
        dialogTitle: widget.dialogTitle,
        type: widget.fileType,
      );
      files = file == null ? const <PlatformFile>[] : <PlatformFile>[file];
    }

    if (files.isEmpty) {
      // User canceled the picker
      return;
    }

    setState(() {
      _controller.text = files.map((element) => element.name).toList().join(', ');
    });
    if (widget.callback != null) widget.callback!(files);
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

  FaIconData asset() {
    return FontAwesomeIcons.file;
  }
}

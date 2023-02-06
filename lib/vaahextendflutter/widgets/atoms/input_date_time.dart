import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/date_time.dart';
import 'package:team/vaahextendflutter/helpers/enums.dart';

enum PickerType { dateOnly, timeOnly, dateAndTime }

typedef ValidatorFun = String? Function(String?);

class DateTimeInput extends StatefulWidget {
  final String label;
  final EdgeInsets padding;
  final double borderRadius;
  final bool isEnabled;
  final InputSize size;
  final PickerType pickerType;
  final DateTime? initialDateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final AutovalidateMode? autoValidateMode;
  final ValidatorFun? validator;
  final Function(dynamic)? callback;

  const DateTimeInput({
    super.key,
    required this.label,
    this.padding = allPadding12,
    this.borderRadius = defaultPadding / 2,
    this.isEnabled = true,
    this.size = InputSize.medium,
    this.pickerType = PickerType.dateOnly,
    this.initialDateTime,
    this.firstDate,
    this.lastDate,
    this.iconBackgroundColor,
    this.iconColor,
    this.autoValidateMode,
    this.validator,
    this.callback,
  });

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  DateTime? date;
  TimeOfDay? time;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: select,
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
          onTap: select,
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
      controller: controller,
      style: TextStyle(
        fontSize: getFontSize(),
        color: AppTheme.colors['black']!.shade400,
      ),
      enabled: widget.isEnabled,
      readOnly: true,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
    );
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

  IconData asset() {
    switch (widget.pickerType) {
      case PickerType.dateOnly:
        return FontAwesomeIcons.calendarDay;
      case PickerType.timeOnly:
        return FontAwesomeIcons.clock;
      case PickerType.dateAndTime:
        return FontAwesomeIcons.calendarXmark;
      default:
        return FontAwesomeIcons.circleExclamation;
    }
  }

  void select() async {
    switch (widget.pickerType) {
      case PickerType.dateOnly:
        await datePicker();
        if (date != null) {
          controller.text = date!.toFullDateString;
        } else {
          controller.text = '';
        }
        if (widget.callback != null) widget.callback!(date);
        break;
      case PickerType.timeOnly:
        await timePicker();
        if (time != null) {
          controller.text = time!.toHMaa;
        } else {
          controller.text = '';
        }
        if (widget.callback != null) widget.callback!(time);
        break;
      case PickerType.dateAndTime:
        await datePicker();
        if (date != null) {
          await timePicker();
        }
        if (date == null || time == null) {
          controller.text = '';
          if (widget.callback != null) widget.callback!(null);
        } else {
          final DateTime datetime =
              DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
          controller.text = datetime.toFullDateTimeString;
          if (widget.callback != null) widget.callback!(datetime);
        }
        break;
      default:
        Console.danger('Error in date time input');
    }
  }

  Future<void> datePicker() async {
    date = await showDatePicker(
      context: context,
      initialDate: widget.initialDateTime ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2050),
    );
    return;
  }

  Future<void> timePicker() async {
    time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        widget.initialDateTime ?? DateTime.now(),
      ),
    );
    return;
  }
}

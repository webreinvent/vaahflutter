import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team/vaahextendflutter/helpers/timezone.dart';

enum TimeZone { utc, local }

extension TimeOfDayExtension on TimeOfDay {
  String formatExt({String format = 'hh:mm a'}) =>
      DateFormat(format).format(DateTime(0, 0, 0, hour, minute));

  // HH:MM AM
  String get toHMaa => DateFormat('hh:mm a').format(DateTime(0, 0, 0, hour, minute));
}

// Extension for DateTime
extension DateTimeExtension on DateTime {
  String toTime(BuildContext context) => TimeOfDay.fromDateTime(asLocal).format(context);

  // Return DateTime with zero millisecond and microsecond
  DateTime get resetMillisecond => DateTime(year, month, day, hour, minute, second);

  DateTime get nowAsUtc => DateTime.now().asUtc;

  DateTime daysBefore(int days) => subtract(Duration(days: days));

  DateTime daysAfter(int days) => add(Duration(days: days));

  DateTime get nextDayStart => onlyDate.daysAfter(1);

  DateTime get localTimeToday {
    DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime get onlyDate => isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

  DateTime get onlyMonth => isUtc ? DateTime.utc(year, month) : DateTime(year, month);

  DateTime onlyTime([int? hourArg, int? minuteArg]) =>
      DateTime.utc(1970, 1, 1, hourArg ?? hour, minuteArg ?? minute, 0, 0, 0);

  DateTime get utcTimeFirstDaySinceEpoch =>
      DateTime.utc(1970, 1, 1, hour, minute, second, millisecond, microsecond);

  // Convert local time as current utc
  // DateTime.now() = 2021-01-25 18:49:03.049422
  // DateTime.asUtc() = 2021-01-25 18:49:03.049422
  // DateTime.toUtc() = 2021-01-25 11:49:03.056208Z
  DateTime get asUtc => isUtc ? this : toUtc();

  DateTime get asLocal => !isUtc ? this : toLocal();

  DateTime get asClient => asLocal;

  DateTime? toTimezone(String timezone, {bool daylight = false}) {
    Duration? difference = TimezoneHelper.getTimezoneUTCOffset(timezone);
    if (difference == null) return null;
    if (!isUtc) {
      return asUtc.add(difference);
    }
    return add(difference);
  }

  DateTime? fromTimezone(String timezone, {bool daylight = false}) {
    Duration? difference = TimezoneHelper.getTimezoneUTCOffset(timezone);
    if (difference == null) return null;
    return subtract(difference);
  }

  // Convert DateTime to String
  String format({String format = 'yyyy MMM dd, h:mm a'}) => DateFormat(format).format(this);

  // Month(short) DD HH:MM AM/PM
  String get toDateTimeString => DateFormat('MMM dd h:mm a').format(this);

  // Day, Month DD HH:MM am/pm
  String get toFullDateTimeString => DateFormat('EEEE, MMMM dd h:mm a').format(this);

  // Day, Month DD am/pm
  String get toFullDateString => DateFormat('EEE, yyyy MMMM dd').format(this);

  // HH:MM am/pm
  String get toHMaa => DateFormat('hh:mm aaaa').format(this);

  // HH:MM:SS am/pm
  String get toHHMMSS => DateFormat('hh:mm:ss a').format(this);

  // Month DD
  String get toMMMMdd => DateFormat('MMMM dd').format(this);

  // Month(short) DD
  String get toMMMdd => DateFormat('MMM dd').format(this);

  // YYYY-MM-DD
  String get toYyyymmmdd => DateFormat('yyyy-MMM-dd').format(this);

  // YYYY-MM-DD
  String get toDateOfBirth => DateFormat('yyyy-MM-dd').format(this);

  // To query format: YYYY-MM-DD
  String get toQueryFormat => DateFormat('yyyy-MM-dd').format(this);
}

// Extension for DateTime from String
extension DateTimeStringExtendsion on String {
  // Convert to DateTime by pattern
  // https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
  DateTime toDateTime({String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(pattern).parse(this, true).toLocal();
  }

  String get safe => this;

  String zeroPrefix(int count) {
    if (length >= count) {
      return this;
    } else {
      String builder = '';
      for (int i = 0; i < count - length; i++) {
        builder += '0';
      }
      builder += this;
      return builder;
    }
  }

  int? get parseInt => int.tryParse(this);

  double? get parseDouble => double.tryParse(this);
}

// Extension for duration
extension DurationExtension on Duration {
  Duration get safe => this;

  String get format => toString().split('.').first.padLeft(8, '0');

  // Add zero padding
  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0${max(n, 0)}';
  }

  // hours:minutes:seconds
  String get toHms {
    final String twoDigitHours = _twoDigits(inHours.remainder(24));
    final String twoDigitMinutes = _twoDigits(inMinutes.remainder(60));
    final String twoDigitSeconds = _twoDigits(inSeconds.remainder(60));
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  // minutes:seconds
  String get toMs {
    final String twoDigitMinutes = _twoDigits(inMinutes.remainder(60));
    final String twoDigitSeconds = _twoDigits(inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

// Extension for int
extension DateExtensions on int {
  DateTime get localDateTime => DateTime.fromMillisecondsSinceEpoch(this, isUtc: false);

  DateTime get utcDateTime => DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);

  DateTime asDateTime({TimeZone from = TimeZone.utc}) {
    switch (from) {
      case TimeZone.local:
        return localDateTime;
      case TimeZone.utc:
      default:
        return utcDateTime;
    }
  }

  DateTime asLocal({TimeZone from = TimeZone.utc}) => asDateTime(from: from).asLocal;

  String toTime(BuildContext context, {TimeZone from = TimeZone.utc}) =>
      asDateTime(from: from).toTime(context);

  int localTimeToday({TimeZone from = TimeZone.utc}) =>
      asDateTime(from: from).localTimeToday.millisecondsSinceEpoch;

  int onlyDate({TimeZone from = TimeZone.utc}) =>
      asDateTime(from: from).onlyDate.millisecondsSinceEpoch;

  int onlyTime({TimeZone from = TimeZone.utc}) =>
      asDateTime(from: from).utcTimeFirstDaySinceEpoch.millisecondsSinceEpoch;

  int utcTimeFirstDaySinceEpoch({TimeZone from = TimeZone.utc}) =>
      asDateTime(from: from).utcTimeFirstDaySinceEpoch.millisecondsSinceEpoch;

  Duration asDuration() => Duration(milliseconds: this);
}

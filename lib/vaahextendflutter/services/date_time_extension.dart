// import 'package:flutter/material.dart';
// // import intl package

// enum TimeZone { utc, local }

// // Extension for DateTime
// extension DateTimeExtension on DateTime {
//   String toTime(BuildContext context) =>
//       TimeOfDay.fromDateTime(asLocal()).format(context);

//   // Return DateTime with zero millisecond and microsecond
//   DateTime resetMillisecond() {
//     return DateTime(year, month, day, hour, minute, second);
//   }

//   DateTime daysBefore(int days) => subtract(Duration(days: days));

//   DateTime daysAfter(int days) => add(Duration(days: days));

//   DateTime nextDayStart() => onlyDate().daysAfter(1);

//   DateTime localTimeToday() => DateTime.now().let(
//         (DateTime now) => DateTime(
//           now.year,
//           now.month,
//           now.day,
//           hour,
//           minute,
//           second,
//           millisecond,
//           microsecond,
//         ),
//       );

//   DateTime onlyDate() =>
//       isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

//   DateTime onlyMonth() =>
//       isUtc ? DateTime.utc(year, month) : DateTime(year, month);

//   DateTime onlyTime([int? hourArg, int? minuteArg]) =>
//       DateTime.utc(1970, 1, 1, hourArg ?? hour, minuteArg ?? minute, 0, 0, 0);

//   DateTime utcTimeFirstDaySinceEpoch() =>
//       DateTime.utc(1970, 1, 1, hour, minute, second, millisecond, microsecond);

//   // Convert local time as current utc
//   // DateTime.now() = 2021-01-25 18:49:03.049422
//   // DateTime.asUtc() = 2021-01-25 18:49:03.049422
//   // DateTime.toUtc() = 2021-01-25 11:49:03.056208Z
//   DateTime asUtc() => isUtc
//       ? this
//       : DateTime.utc(
//           year,
//           month,
//           day,
//           hour,
//           minute,
//           second,
//           millisecond,
//           microsecond,
//         );

//   DateTime asLocal() => !isUtc
//       ? this
//       : DateTime(
//           year,
//           month,
//           day,
//           hour,
//           minute,
//           second,
//           millisecond,
//           microsecond,
//         );

//   // Convert DateTime to String
//   // Month(short) DD HH:MM AM/PM
//   String toDateTimeString() {
//     return DateFormat('MMM dd  h:mm a').format(this);
//   }

//   // Day, Month DD / HH:MM am/pm
//   String toFullDateTimeString() {
//     return DateFormat('EEEE, MMMM dd / h:mm a').format(this);
//   }

//   // HH:MM AM
//   String toHmaa() {
//     return DateFormat('hh:mm aaaa').format(this);
//   }

//   // HH:MM:SS
//   String toHHMMSS() {
//     return DateFormat('hh:mm:ss').format(this);
//   }

//   // Month DD
//   String toMMMMdd() {
//     return DateFormat('MMMM dd').format(this);
//   }

//   // Month(short) DD
//   String toMMMdd() {
//     return DateFormat('MMM dd').format(this);
//   }

//   // YYYY-MM-DD
//   String toDateOfBirth() {
//     return DateFormat('yyyy-MM-dd').format(this);
//   }

//   // To query format: YYYY-MM-DD
//   String toQueryFormat() {
//     return DateFormat('yyyy-MM-dd').format(this);
//   }
// }

// // Extension for DateTime from String
// extension DateTimeStringExtendsion on String {
//   // Check Null or Empty
//   bool get isNullOrEmpty => isNull || isEmpty;

//   // Convert to DateTime by pattern
//   // https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
//   DateTime toDateTime({String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
//     return isNullOrEmpty
//         ? null
//         : DateFormat(pattern).parse(this, true).toLocal();
//   }

//   String safe([String supplier()]) =>
//       this ?? (supplier == null ? '' : supplier());

//   String zeroPrefix(int count) {
//     if (length >= count) {
//       return this;
//     } else {
//       String builder = '';
//       for (int i = 0; i < count - length; i++) {
//         builder += '0';
//       }
//       builder += this;
//       return builder;
//     }
//   }

//   int parseInt() => int.tryParse(this);

//   double parseDouble() => double.tryParse(this);

//   String truncate(int limit) {
//     return length > limit
//         ? '${substring(0, min(length, limit)).trim()}...'
//         : this;
//   }
// }

// // Extension for duration
// extension DurationExtension on Duration {
//   Duration safe([Duration supplier()]) =>
//       this ?? (supplier == null ? Duration.zero : supplier());

//   String format() {
//     return toString().split('.').first.padLeft(8, '0');
//   }

//   // Add zero padding
//   String _twoDigits(int n) {
//     if (n >= 10) {
//       return '$n';
//     }
//     return '0${max(n, 0)}';
//   }

//   // hours:minutes:seconds
//   String toHms() {
//     final String twoDigitHours = _twoDigits(inHours.remainder(24) as int);
//     final String twoDigitMinutes = _twoDigits(inMinutes.remainder(60) as int);
//     final String twoDigitSeconds = _twoDigits(inSeconds.remainder(60) as int);
//     return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
//   }

//   // minutes:seconds
//   String toMs() {
//     final String twoDigitMinutes = _twoDigits(inMinutes.remainder(60) as int);
//     final String twoDigitSeconds = _twoDigits(inSeconds.remainder(60) as int);
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }
// }

// // Extension for int
// extension DateExtensions on int {
//   DateTime localDateTime() =>
//       DateTime.fromMillisecondsSinceEpoch(this, isUtc: false);

//   DateTime utcDateTime() =>
//       DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);

//   DateTime asDateTime({TimeZone from = TimeZone.utc}) {
//     switch (from) {
//       case TimeZone.local:
//         return localDateTime();
//       case TimeZone.utc:
//       default:
//         return utcDateTime();
//     }
//   }

//   DateTime asLocal({TimeZone from = TimeZone.utc}) =>
//       asDateTime(from: from).asLocal();

//   String toTime(BuildContext context, {TimeZone from = TimeZone.utc}) =>
//       asDateTime(from: from).toTime(context);

//   int localTimeToday({TimeZone from = TimeZone.utc}) =>
//       asDateTime(from: from).localTimeToday().millisecondsSinceEpoch;

//   int onlyDate({TimeZone from = TimeZone.utc}) =>
//       asDateTime(from: from).onlyDate().millisecondsSinceEpoch;

//   int onlyTime({TimeZone from = TimeZone.utc}) =>
//       asDateTime(from: from).utcTimeFirstDaySinceEpoch().millisecondsSinceEpoch;

//   int utcTimeFirstDaySinceEpoch({TimeZone from = TimeZone.utc}) =>
//       asDateTime(from: from).utcTimeFirstDaySinceEpoch().millisecondsSinceEpoch;

//   Duration asDuration() => Duration(milliseconds: this);
// }

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => (this ?? "").isEmpty;

  bool get isNotNullAndNotEmpty => !isNullOrEmpty;
}

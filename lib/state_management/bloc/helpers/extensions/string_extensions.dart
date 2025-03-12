extension StringExtensions on String {
  bool get isAlphabetOnly => RegExp(r'^[a-zA-Z]+$').hasMatch(this);
}

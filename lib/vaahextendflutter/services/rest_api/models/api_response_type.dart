class ApiResponseType {
  final bool success;
  final dynamic data;
  final List<String>? messages;
  final String? hint;

  const ApiResponseType({
    required this.success,
    required this.data,
    this.messages,
    this.hint,
  });

  @override
  String toString() {
    return 'ApiResponseType{success: $success, data: $data, messages: ${messages?.join(' ')}, hint: $hint}';
  }
}

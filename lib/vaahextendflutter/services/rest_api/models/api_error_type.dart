enum ApiErrorCode { unknown, unauthorized }

class ApiErrorType {
  final ApiErrorCode code;
  final List<String> errors;
  final String? debug;

  const ApiErrorType({
    this.code = ApiErrorCode.unknown,
    this.errors = const ['Unknown'],
    this.debug,
  });

  @override
  String toString() {
    return 'ApiErrorType{code: $code, errors: ${errors.join(' ')}, debug: $debug}';
  }
}

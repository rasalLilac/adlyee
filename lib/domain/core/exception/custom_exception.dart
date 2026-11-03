// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomException implements Exception {
  CustomException({
    required this.errMsg,
    this.stackTrace,
  });
  final String errMsg;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'CustomException(errMsg: $errMsg, stackTrace: $stackTrace)';
}

class CustomFormValidationException implements Exception {
  CustomFormValidationException({
    required this.errors,
    this.stackTrace,
  });
  final List<Map<String, String>> errors;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'CustomException(errMsg: $errors, stackTrace: $stackTrace)';
}

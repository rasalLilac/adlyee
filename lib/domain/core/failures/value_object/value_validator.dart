import 'package:dartz/dartz.dart';
import 'package:solofy_vendor_app/domain/core/failures/value_object/value_failure.dart';

Either<ValueFailure<String>, String> validateMail(String mail) {
  final RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (!emailRegExp.hasMatch(mail)) {
    return left(
      const ValueFailure.invalidValue('Enter a valid mail'),
    );
  }
  return right(mail);
}

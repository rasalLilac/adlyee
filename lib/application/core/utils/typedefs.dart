import 'package:dartz/dartz.dart';
import 'package:solofy_vendor_app/domain/core/failures/failures.dart';

/// A type alias for an `Either` type that can hold a `MainFailure` or a value of type `T`.
///
/// `Result<T>` represents a value that can be either a `MainFailure` (indicating an error)
/// or a `T` (indicating a successful result). This is useful for functions that can either
/// succeed with a value of type `T` or fail with a `MainFailure`.
///
/// Example:
/// ```dart
/// Result<String> getName(bool shouldFail) {
///   if (shouldFail) {
///     return Left(MainFailure());
///   } else {
///     return Right("John Doe");
///   }
/// }
/// ```
typedef Result<T> = Either<MainFailure, T>;

/// A type alias for a `Future` that resolves to a `Result`.
///
/// `ResultFuture<T>` represents a `Future` that will complete with a
/// `Result<T>`. A `Result<T>` is an `Either<MainFailure, T>`, meaning it
/// can be either a `MainFailure` (indicating an error) or a `T` (indicating a successful result).
///
/// This type alias is useful for functions that perform asynchronous
/// operations and return a `Result` indicating either success or failure.
///
/// Example:
/// ```dart
/// ResultFuture<String> fetchData() async {
///   try {
///     final data = await apiCall();
///     return Right(data);
///   } catch (e) {
///     return Left(MainFailure());
///   }
/// }
/// ```
typedef ResultFuture<T> = Future<Result<T>>;

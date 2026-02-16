import 'package:dartz/dartz.dart';
import '../../../core/utils/errors/failures.dart';

typedef ValidationResult<T> = Either<Failure, T>;

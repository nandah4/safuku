import 'package:dartz/dartz.dart';
import '../entities/category.dart';
import '../../core/utils/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, int>> createCategory(CategoryEntity category);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}

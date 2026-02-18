import 'package:dartz/dartz.dart';

import '../../core/utils/errors/failures.dart';
import '../mapper/category_mapper.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/local/category_local.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/errors/exception.dart' as failure;

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _categoryLocalDataSource;

  CategoryRepositoryImpl({
    required CategoryLocalDataSource categoryLocalDataSource,
  }) : _categoryLocalDataSource = categoryLocalDataSource;

  @override
  Future<Either<Failure, int>> createCategory(CategoryEntity category) async {
    try {
      final categoryModel = category.toModel().copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await _categoryLocalDataSource.createCategory(
        categoryModel,
      );
      AppLogger.i(
        "REPOSITORY : Category created successfully ${categoryModel.toMap()}",
      );
      return Right(result);
    } on failure.DatabaseException catch (e) {
      AppLogger.e("REPOSITORY : Category creation failed ${e.toString()}");
      return Left(
        DatabaseFailure(
          title: "Item already exists",
          message: "Category name already exists",
        ),
      );
    } on failure.UnknownException catch (e) {
      AppLogger.e("REPOSITORY : Category creation failed ${e.toString()}");
      return Left(UnknownFailure());
    } catch (e) {
      AppLogger.e("REPOSITORY : Category creation failed ${e.toString()}");
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final result = await _categoryLocalDataSource.getAllCategories();
      AppLogger.i("REPOSITORY : Category loaded successfully ${result.length}");
      return Right(result.map((data) => data.toEntity()).toList());
    } on failure.DatabaseException catch (e) {
      AppLogger.e("REPOSITORY : Category loading failed ${e.toString()}");
      return Left(DatabaseFailure());
    } on failure.UnknownException catch (e) {
      AppLogger.e("REPOSITORY : Category loading failed ${e.toString()}");
      return Left(UnknownFailure());
    } catch (e) {
      AppLogger.e("REPOSITORY : Category loading failed ${e.toString()}");
      return Left(UnknownFailure());
    }
  }
}

import '../../domain/entities/category.dart';
import '../models/category.dart';

extension CategoryEntityToModel on CategoryEntity {
  Category toModel() {
    return Category(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CategoryModelToEntity on Category {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

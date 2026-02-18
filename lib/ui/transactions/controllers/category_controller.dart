import 'package:flutter/widgets.dart';

import '../../../domain/repositories/category_repository.dart';
import '../../../domain/entities/category.dart';
import '../../../core/utils/errors/failures.dart';
import '../../../core/utils/logger.dart';
import 'package:get/get.dart';

import '../../core/utils/snackbar_helper.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository;
  late final GlobalKey<FormState> formKey;
  late TextEditingController categoryNameController;

  CategoryController({required CategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    categoryNameController = TextEditingController();
    getCategories();
  }

  @override
  void onClose() {
    categoryNameController.dispose();
    super.onClose();
  }

  RxBool isLoading = false.obs;
  final categories = RxList<CategoryEntity>([]);

  Future<void> createCategory(String name) async {
    isLoading.value = true;
    try {
      final result = await _categoryRepository.createCategory(
        CategoryEntity(name: name),
      );
      result.fold(
        (failure) {
          SnackbarHelper.showError(failure);
        },
        (category) {
          AppLogger.i("Category created successfully $category");
        },
      );
      getCategories();
    } catch (e) {
      SnackbarHelper.showError(UnknownFailure());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCategories() async {
    isLoading.value = true;
    try {
      final result = await _categoryRepository.getAllCategories();

      result.fold(
        (failure) {
          AppLogger.e("Failed to fetch categories ${failure.message}");
          SnackbarHelper.showError(failure);
        },
        (categoryList) {
          categories.assignAll(categoryList);
          AppLogger.i("Categories fetched successfully ${categoryList.length}");
        },
      );
    } catch (e) {
      AppLogger.e("catch Failed to fetch categories ${e.toString()}");
      SnackbarHelper.showError(UnknownFailure());
    } finally {
      isLoading.value = false;
    }
  }
}

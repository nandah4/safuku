import 'package:get/get.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';

class SnackbarHelper {
  static void showError(Failure failure) {
    Get.snackbar(
      failure.title ?? 'Error Title',
      failure.message ?? 'Error Message',
      backgroundColor: AppColors.error,
      colorText: AppColors.text,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
}

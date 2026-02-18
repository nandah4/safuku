import 'package:get/get.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';

class SnackbarHelper {
  static void showError(Failure failure) {
    Get.snackbar(
      failure.title ?? Get.context!.localizations.errorGeneric,
      failure.message ?? Get.context!.localizations.somethingWentWrong,
      backgroundColor: AppColors.error,
      colorText: AppColors.text,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
}

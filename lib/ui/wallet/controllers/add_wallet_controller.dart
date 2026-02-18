import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:safuku/core/utils/errors/failures.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/core/utils/snackbar_helper.dart';
import 'package:safuku/core/utils/logger.dart';

import 'package:safuku/domain/entities/wallet.dart';
import 'package:safuku/domain/repositories/wallet_repository.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';

import 'package:safuku/ui/core/utils/amount_validator.dart';
import 'package:safuku/l10n/app_localizations.dart';

class AddWalletController extends GetxController {
  // Repository
  final WalletRepository walletRepository;
  final FormatterInterface _formatter;
  final AppEventBus _eventBus;

  // DATA
  final WalletEntity? wallet;

  AddWalletController({
    required this.walletRepository,
    required FormatterInterface formatter,
    required AppEventBus eventBus,
    this.wallet,
  }) : _formatter = formatter,
       _eventBus = eventBus;

  // GLOBAL KEY
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // CONTROLLERS
  late final TextEditingController amountController;
  late final TextEditingController nameController;

  @override
  void onInit() {
    super.onInit();

    amountController = TextEditingController(
      text: wallet != null
          ? _formatter.formatAmountWithoutCurrency(wallet!.saldo)
          : "",
    );

    nameController = TextEditingController(text: wallet?.name);
    currentColor.value = wallet?.color?.toColor() ?? AppColors.primary;
    isEdit = wallet != null;

    // Listener for check button disabled
    amountController.addListener(checkButtonDisabled);
    nameController.addListener(checkButtonDisabled);

    checkButtonDisabled();
  }

  @override
  void onClose() {
    amountController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // STATE
  Rx<Color?> currentColor = AppColors.primary.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isButtonDisabled = true.obs;
  bool isEdit = false;

  void checkButtonDisabled() {
    isButtonDisabled.value =
        amountController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty;
  }

  Rx<String?> amountError = Rx<String?>(null);

  void setColor(Color? color) {
    currentColor.value = color ?? AppColors.primary;
  }

  // METHOD - Submit wallet included create or update
  Future<void> submitWallet() async {
    isLoading.value = true;

    try {
      final amountValidated = AmountValidator.validateAmount(
        amountController.text,
        AppLocalizations.of(Get.context!)!,
      );
      if (amountValidated != null) {
        amountError.value = amountValidated;
        AppLogger.e(
          "CONTROLLER (FAILED VALIDATE AMOUNT) : ${amountError.value}",
        );
        return;
      }

      final amountResult = AmountValidator.parseAmount(amountController.text);

      if (amountResult == null) {
        AppLogger.e("CONTROLLER (FAILED PARSE AMOUNT) : $amountResult");
        amountError.value = AppLocalizations.of(Get.context!)!.amountInvalid;
        return;
      }

      if (isEdit) {
        final updateWalletResult = await walletRepository.updateWallet(
          _buildWallet(),
        );

        updateWalletResult.fold(
          (failure) {
            AppLogger.e(
              "CONTROLLER (FAILED UPDATE WALLET) : ${failure.message}",
            );
            SnackbarHelper.showError(
              Failure(
                title: "Error",
                message: failure.message ?? "Failed to update wallet",
              ),
            );
          },
          (rows) {
            AppLogger.i("CONTROLLER (SUCCESS UPDATE WALLET)");
            _eventBus.emit(AppEvent.walletChanged);
            Get.back();
          },
        );
        return;
      }

      final createWalletResult = await walletRepository.createWallet(
        _buildWallet(),
      );

      createWalletResult.fold(
        (failure) {
          AppLogger.e("CONTROLLER (FAILED CREATE WALLET) : ${failure.message}");
          SnackbarHelper.showError(
            Failure(
              title: "Error",
              message: failure.message ?? "Failed to create wallet",
            ),
          );
        },
        (id) {
          AppLogger.i("CONTROLLER (SUCCESS CREATE WALLET)");
          amountError.value = null;
          Get.find<AppEventBus>().emit(AppEvent.walletChanged);
          Get.back();
        },
      );
    } catch (e) {
      AppLogger.e("CONTROLLER (FAILED SUBMIT WALLET) : $e");

      SnackbarHelper.showError(
        Failure(title: "Error", message: "Failed to submit wallet"),
      );
    } finally {
      isLoading.value = false;
    }
  }

  WalletEntity _buildWallet() {
    return WalletEntity(
      id: wallet?.id,
      name: nameController.text,
      saldo: AmountValidator.parseAmount(amountController.text)!,
      color: currentColor.value?.toHexString(),
      createdAt: wallet?.createdAt,
      updatedAt: wallet?.updatedAt,
    );
  }
}

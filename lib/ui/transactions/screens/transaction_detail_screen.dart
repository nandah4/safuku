import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/modal_delete_item.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';
import 'package:safuku/ui/transactions/controllers/transaction_detail_controller.dart';
import 'package:safuku/ui/transactions/widgets/item_detail.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionDetailController _detailController =
      Get.find<TransactionDetailController>();

  TransactionDetailScreen({super.key});

  Widget _transactionTypeBadge(BuildContext context, String? type) {
    final Color statusColor = type == "expense"
        ? AppColors.error
        : AppColors.success;
    final Color statusBgColor = type == "expense"
        ? AppColors.errorBackground
        : AppColors.successBackground;
    final IconData typeIcon = type == "expense"
        ? FontAwesomeIcons.arrowTrendDown
        : FontAwesomeIcons.arrowTrendUp;
    final String typeText = type == "expense"
        ? context.localizations.labelExpense
        : context.localizations.labelIncome;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingScale.md,
        vertical: PaddingScale.sm,
      ),
      decoration: BoxDecoration(
        color: statusBgColor,
        borderRadius: BorderRadius.circular(BorderRadiusScale.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(typeIcon, size: IconSizeScale.xs, color: statusColor),
          const SizedBox(width: SpacingScale.lg),
          Text(
            typeText,
            style: context.textTheme.labelMedium?.copyWith(color: statusColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            snap: true,
            floating: true,
            title: Text(
              context.localizations.transactionDetail,
              style: context.textTheme.titleLarge,
            ),
            centerTitle: false,
            leading: IconButton(
              padding: .zero,
              visualDensity: .compact,
              highlightColor: Colors.transparent,
              onPressed: () => Get.back(),
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                size: IconSizeScale.md,
              ),
              color: context.colorExtension.textLabel,
            ),
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: Colors.transparent,

            actions: [
              IconButton(
                padding: .zero,
                visualDensity: .compact,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Get.toNamed(
                    '/add-transaction',
                    arguments: {
                      'transaction': _detailController.transactionData.value,
                    },
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.penToSquare,
                  size: IconSizeScale.md,
                ),
                color: context.colorExtension.textLabel,
              ),
              IconButton(
                padding: .zero,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    backgroundColor: context.colorScheme.surface,
                    builder: (context) {
                      return ModalDeleteItem(
                        icon: FontAwesomeIcons.trash,
                        iconColor: AppColors.error,
                        title:
                            "${_detailController.transactionData.value?.title}",
                        description:
                            context.localizations.deleteTransactionConfirm,
                        onDelete: () {
                          // Close modal first
                          Get.back();
                          _detailController.deleteTransaction();
                        },
                      );
                    },
                  );
                },
                highlightColor: Colors.transparent,
                icon: const Icon(
                  FontAwesomeIcons.trash,
                  size: IconSizeScale.md,
                ),
                color: AppColors.error,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingScale.md,
                vertical: PaddingScale.sm,
              ),
              child: Column(
                children: [
                  Obx(
                    () => Skeletonizer(
                      justifyMultiLineText: false,
                      textBoneBorderRadius:
                          TextBoneBorderRadius.fromHeightFactor(0.4),
                      enabled: _detailController.isLoading.value,
                      child: _transactionTypeBadge(
                        context,
                        _detailController.transactionData.value?.type,
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingScale.lg),
                  Text(
                    context.localizations.totalAmount,
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: SpacingScale.sm),
                  Obx(
                    () => Skeletonizer(
                      justifyMultiLineText: false,
                      textBoneBorderRadius:
                          TextBoneBorderRadius.fromHeightFactor(0.4),
                      enabled: _detailController.isLoading.value,
                      child: Text(
                        Get.find<FormatterInterface>().formatAmountWithCurrency(
                          _detailController.transactionData.value?.amount ?? 0,
                        ),
                        style: context.textStyleExtension.currencyLarge
                            ?.copyWith(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Body Content ───
          SliverPadding(
            padding: const EdgeInsets.all(PaddingScale.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: SpacingScale.sm),
                Obx(
                  () => Skeletonizer(
                    justifyMultiLineText: false,
                    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(
                      0.4,
                    ),
                    enabled: _detailController.isLoading.value,
                    child: ItemDetail(
                      label: context.localizations.category,
                      value:
                          _detailController
                              .transactionData
                              .value
                              ?.categoryName ??
                          '',
                      icon: FontAwesomeIcons.tag,
                      iconColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingScale.md),
                Obx(
                  () => Skeletonizer(
                    justifyMultiLineText: false,
                    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(
                      0.4,
                    ),
                    enabled: _detailController.isLoading.value,
                    child: ItemDetail(
                      label: context.localizations.title,
                      value:
                          _detailController.transactionData.value?.title ?? '',
                      icon: FontAwesomeIcons.cartShopping,
                      iconColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingScale.md),
                Obx(
                  () => Skeletonizer(
                    justifyMultiLineText: false,
                    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(
                      0.4,
                    ),
                    enabled: _detailController.isLoading.value,
                    child: ItemDetail(
                      label: context.localizations.wallet,
                      value:
                          _detailController.transactionData.value?.walletName ??
                          '',
                      icon: FontAwesomeIcons.wallet,
                      iconColor:
                          _detailController.transactionData.value?.walletColor
                              ?.toColor() ??
                          AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingScale.md),
                Obx(
                  () => Skeletonizer(
                    justifyMultiLineText: false,
                    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(
                      0.4,
                    ),
                    enabled: _detailController.isLoading.value,
                    child: ItemDetail(
                      label: context.localizations.date,
                      value: DateFormat('dd MMMM yyyy').format(
                        DateTime.tryParse(
                              _detailController.transactionData.value?.date
                                      .toString() ??
                                  '',
                            ) ??
                            DateTime.now(),
                      ),
                      icon: FontAwesomeIcons.calendar,
                      iconColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingScale.md),

                // ─── Notes Card ───
                Obx(
                  () => Skeletonizer(
                    justifyMultiLineText: false,
                    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(
                      0.4,
                    ),
                    enabled: _detailController.isLoading.value,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(PaddingScale.lg),
                      decoration: BoxDecoration(
                        color: context.colorExtension.bgCard,
                        borderRadius: BorderRadius.circular(
                          BorderRadiusScale.sm,
                        ),
                        border: Border.all(
                          color:
                              context.colorExtension.outlinedBorder ??
                              Colors.transparent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: WalletCardSizeScale.widthAndHeight,
                                height: WalletCardSizeScale.widthAndHeight,
                                padding: const EdgeInsets.all(PaddingScale.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    BorderRadiusScale.sm,
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.noteSticky,
                                  size: IconSizeScale.md,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: SpacingScale.md),
                              Text(
                                context.localizations.notes,
                                style: context.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingScale.md),
                          Text(
                            _detailController
                                        .transactionData
                                        .value
                                        ?.description
                                        ?.isNotEmpty ==
                                    true
                                ? _detailController
                                      .transactionData
                                      .value!
                                      .description!
                                : context.localizations.writeNotesHere,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: context.colorExtension.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom padding
                const SizedBox(height: SpacingScale.xl * 2),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

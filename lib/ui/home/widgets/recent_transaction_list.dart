import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/transaction_card_widget.dart';
import 'package:safuku/ui/home/controllers/home_controller.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:safuku/ui/core/controllers/shell_controller.dart';

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({super.key});

  final HomeController _homeController = Get.find<HomeController>();
  final ShellController _shellController = Get.find<ShellController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.localizations.recentTransaction,
                style: context.textTheme.titleSmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _shellController.changeIndex(2),
                child: Text(
                  context.localizations.seeAll,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingScale.sm),
          Obx(() {
            if (_homeController.recentTransaction.value.isEmpty) {
              return SizedBox(
                height: 230,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.clockRotateLeft,
                        size: IconSizeScale.xl,
                        color: context.colorExtension.textLabel,
                      ),
                      const SizedBox(height: SpacingScale.lg),
                      Text(
                        context.localizations.noTransactionsYet,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colorExtension.textLabel,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: PaddingScale.lg),
              itemCount: _homeController.recentTransaction.value.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final transaction =
                    _homeController.recentTransaction.value[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(BorderRadiusScale.md),
                  onTap: () =>
                      Get.toNamed('/transaction-detail/${transaction.id}'),
                  child: TransactionCardWidget(
                    icon: FontAwesomeIcons.moneyBill,
                    type: transaction.type,
                    title: transaction.title,
                    category: transaction.categoryName ?? "-",
                    amount: transaction.amount,
                    date: transaction.date,
                    wallet: transaction.walletName ?? "-",
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: SpacingScale.sm),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/transaction_card_widget.dart';
import 'package:safuku/ui/home/controllers/home_controller.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({super.key});

  final HomeController _homeController = Get.find<HomeController>();

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
                onPressed: () {},
                child: Text(
                  context.localizations.seeAll,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingScale.sm),
          Obx(() {
            if (_homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_homeController.recentTransaction.value.isEmpty) {
              return Center(
                child: Text(
                  "No transactions yet",
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorExtension.textLabel,
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

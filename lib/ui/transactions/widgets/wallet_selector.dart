import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/error_label.dart';
import 'package:safuku/ui/core/ui/selectable_chip.dart';
import '../controllers/transaction_controller.dart';

/// Section widget for selecting a wallet.
class WalletSelector extends StatelessWidget {
  final TransactionController controller;

  const WalletSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
          child: Text(
            context.localizations.wallet,
            style: context.textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: SpacingScale.sm),
        Obx(() {
          final wallets = controller.wallets.value;
          // Read walletId here so Obx tracks it (itemBuilder runs during layout, not build)
          final selectedWalletId = controller.walletId.value;

          if (wallets.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
              child: Text(
                "No wallets found",
                style: context.textTheme.labelLarge,
              ),
            );
          }

          return SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
              scrollDirection: Axis.horizontal,
              itemCount: wallets.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: SpacingScale.md),
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                final isSelected = selectedWalletId == wallet.id.toString();

                return SelectableChip(
                  isSelected: isSelected,
                  onTap: () {
                    controller.walletId.value = wallet.id.toString();
                    controller.walletError.value = "";
                  },
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.wallet,
                        size: IconSizeScale.sm,
                        color: wallet.color?.toColor() ?? AppColors.primary,
                      ),
                      const SizedBox(width: SpacingScale.md),
                      Text(wallet.name, style: context.textTheme.labelMedium),
                    ],
                  ),
                );
              },
            ),
          );
        }),
        Obx(() {
          if (controller.walletError.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
            child: ErrorLabel(error: controller.walletError.value),
          );
        }),
      ],
    );
  }
}

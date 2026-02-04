import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/modal_delete_item.dart';
import 'package:safuku/ui/wallet/widgets/add_wallet_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),

        child: AppBar(
          surfaceTintColor: context.colorScheme.surface,
          elevation: 0.0,
          title: Text('Wallet', style: context.textTheme.titleLarge),
          centerTitle: false,
          actions: [
            IconButton(
              color: context.colorExtension.textPrimary,
              onPressed: () {
                showModalBottomSheet(
                  useRootNavigator: true,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxHeight: context.screenSize.height * 0.9,
                  ),
                  context: context,
                  builder: (context) {
                    return AddWalletWidget();
                  },
                );
              },
              icon: Icon(FontAwesomeIcons.plus, size: IconSizeScale.md),
            ),
            const SizedBox(width: SpacingScale.xs),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: .symmetric(horizontal: SpacingScale.lg),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              const SizedBox(height: SpacingScale.lg),
              Container(
                width: double.infinity,
                padding: .symmetric(
                  horizontal: PaddingScale.xl,
                  vertical: PaddingScale.xl * 1.5,
                ),
                decoration: BoxDecoration(
                  color: context.colorExtension.bgCard,
                  borderRadius: .circular(BorderRadiusScale.sm),
                  border: Border.all(
                    color:
                        context.colorExtension.outlinedBorder ??
                        AppColors.outlinedBorderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      "Total Amount",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: SpacingScale.xs),
                    Text(
                      "Rp. 100.000.000,00",
                      style: context.textStyleExtension.currencyLarge
                          ?.copyWith(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpacingScale.xl),
              Ink(
                child: InkWell(
                  borderRadius: .circular(BorderRadiusScale.sm),
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      builder: (context) {
                        return ModalDeleteItem(
                          iconColor: AppColors.error,
                          icon: FontAwesomeIcons.wallet,
                          title: "Delete Wallet",
                          description:
                              "Are you sure you want to delete this wallet?",
                          onDelete: () {
                            print("Delete");
                          },
                        );
                      },
                    );
                    print("Long Press");
                  },
                  child: Container(
                    padding: .all(PaddingScale.xl),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorExtension.bgCard,
                      borderRadius: .circular(BorderRadiusScale.sm),
                      border: Border.all(
                        color:
                            context.colorExtension.outlinedBorder ??
                            AppColors.outlinedBorderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: WalletCardSizeScale.widthAndHeight,
                          height: WalletCardSizeScale.widthAndHeight,
                          decoration: BoxDecoration(
                            color: AppColors.successBackground,
                            borderRadius: .circular(BorderRadiusScale.sm),
                          ),
                          child: Icon(
                            FontAwesomeIcons.wallet,
                            size: IconSizeScale.sm,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: SpacingScale.md),
                        Text(
                          "BRI",
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Rp. 100.000.000,00",
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

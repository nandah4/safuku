import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:safuku/domain/entities/wallet.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/modal_delete_item.dart';
import 'package:safuku/ui/core/utils/app_event_bus.dart';
import 'package:safuku/ui/core/utils/formatter_interface.dart';
import 'package:safuku/ui/wallet/controllers/add_wallet_controller.dart';
import 'package:safuku/ui/wallet/controllers/wallet_controller.dart';
import 'package:safuku/ui/wallet/widgets/add_wallet_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletScreen extends StatelessWidget {
  final WalletController _walletControllers = Get.find();
  final FormatterInterface _formatter = Get.find<FormatterInterface>();

  WalletScreen({super.key});

  // Showing wallet modal (create or update)
  void _showWalletModal(BuildContext context, {WalletEntity? wallet}) {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: context.screenSize.height * 0.95),
      context: context,
      builder: (_) {
        return GetBuilder<AddWalletController>(
          init: AddWalletController(
            walletRepository: Get.find(),
            formatter: Get.find<FormatterInterface>(),
            eventBus: Get.find<AppEventBus>(),
            wallet: wallet,
          ),
          builder: (controller) {
            return AddWalletWidget();
          },
        );
      },
    ).whenComplete(() {
      _walletControllers.getAllWallets();
      _walletControllers.getTotalSaldo();
    });
  }

  SliverAppBar _appBar(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: context.colorScheme.surface,
      backgroundColor: context.colorScheme.surface,
      pinned: true,
      elevation: 0.3,
      title: Text(
        context.localizations.wallet,
        style: context.textTheme.titleLarge,
      ),
      centerTitle: false,
      actions: [
        IconButton(
          color: context.colorExtension.textPrimary,
          onPressed: () => _showWalletModal(context),
          icon: Icon(FontAwesomeIcons.plus, size: IconSizeScale.md),
        ),
        const SizedBox(width: SpacingScale.xs),
      ],
    );
  }

  SliverToBoxAdapter _containerTotalAmount(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: .symmetric(horizontal: PaddingScale.lg),
        child: Container(
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
                context.localizations.totalAmount,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              const SizedBox(height: SpacingScale.sm),
              Obx(() {
                return Text(
                  _formatter.formatAmountWithCurrency(
                    _walletControllers.totalSaldo.value,
                  ),
                  style: context.textStyleExtension.currencyLarge?.copyWith(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  SliverPadding _walletList(BuildContext context) {
    return SliverPadding(
      padding: .symmetric(horizontal: PaddingScale.lg),
      sliver: SliverToBoxAdapter(
        child: Obx(() {
          if (_walletControllers.wallets.isEmpty) {
            return SizedBox(
              height: 230,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.wallet,
                      size: IconSizeScale.xl,
                      color: context.colorExtension.textLabel,
                    ),
                    const SizedBox(height: SpacingScale.lg),
                    Text(
                      context.localizations.walletEmpty,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorExtension.textLabel,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            scrollDirection: .vertical,
            physics: ScrollPhysics(),
            itemCount: _walletControllers.wallets.length,
            itemBuilder: (context, index) {
              final wallet = _walletControllers.wallets[index];
              return Ink(
                child: InkWell(
                  borderRadius: .circular(BorderRadiusScale.sm),
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      showDragHandle: true,
                      backgroundColor: context.colorScheme.surface,
                      builder: (context) {
                        return ModalDeleteItem(
                          iconColor: AppColors.error,
                          icon: FontAwesomeIcons.wallet,
                          title: wallet.name,
                          description:
                              context.localizations.deleteWalletConfirm,
                          onDelete: () {
                            _walletControllers.deleteWallet(wallet.id);
                            Get.back();
                          },
                        );
                      },
                    );
                  },
                  onTap: () {
                    _showWalletModal(context, wallet: wallet);
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
                            color: wallet.color?.toColor()?.withValues(
                              alpha: 0.20,
                            ),
                            borderRadius: .circular(BorderRadiusScale.sm),
                          ),
                          child: Icon(
                            FontAwesomeIcons.wallet,
                            size: IconSizeScale.sm,
                            color: wallet.color?.toColor(),
                          ),
                        ),
                        const SizedBox(width: SpacingScale.md),
                        Text(
                          wallet.name,
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatter.formatAmountWithCurrency(wallet.saldo),
                          style: context.textTheme.labelMedium?.copyWith(
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: SpacingScale.md);
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        scrollDirection: .vertical,
        slivers: [
          _appBar(context),
          _containerTotalAmount(context),
          SliverToBoxAdapter(child: const SizedBox(height: SpacingScale.md)),
          _walletList(context),
        ],
      ),
    );
  }
}

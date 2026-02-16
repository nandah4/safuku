import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/home/controllers/home_controller.dart';
import 'package:safuku/ui/home/widgets/home_app_bar.dart';
import 'package:safuku/ui/home/widgets/home_header.dart';
import 'package:safuku/ui/home/widgets/recent_transaction_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surface,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _homeController.scrollController,
            slivers: [
              SliverToBoxAdapter(child: HomeHeader()),
              SliverToBoxAdapter(child: RecentTransactionList()),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: HomeAppBar()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/reports/screens/history_tab.dart';
import 'package:safuku/ui/reports/screens/statistic_tab.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              surfaceTintColor: context.colorScheme.surface,
              backgroundColor: context.colorScheme.surface,
              toolbarHeight: 0,
              bottom: TabBar(
                indicatorColor: context.colorScheme.primary,
                overlayColor: WidgetStatePropertyAll(
                  context.colorExtension.buttonMuted ?? Colors.transparent,
                ),
                tabs: [
                  Tab(
                    child: Text(
                      context.localizations.statistic,
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                  Tab(
                    child: Text(
                      context.localizations.history,
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color:
                      context.colorExtension.outlinedBorder ??
                      Colors.transparent,
                ),
              ),
            ),
          ];
        },

        body: TabBarView(children: [StatisticTab(), HistoryTab()]),
      ),
    );
  }
}

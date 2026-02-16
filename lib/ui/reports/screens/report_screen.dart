import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/reports/screens/history_tab.dart';

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
              title: Text('Reports', style: context.textTheme.titleLarge),
              bottom: TabBar(
                indicatorColor: context.colorScheme.primary,
                overlayColor: WidgetStatePropertyAll(
                  context.colorExtension.buttonMuted ?? Colors.transparent,
                ),
                tabs: [
                  Tab(
                    child: Text(
                      'Statistics',
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                  Tab(
                    child: Text('History', style: context.textTheme.labelLarge),
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

        body: TabBarView(
          children: [
            Center(child: Text('Statistics')),
            HistoryTab(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/reports/screens/history_tab.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          title: Text('Reports', style: context.textTheme.titleLarge),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Statistics', style: context.textTheme.labelLarge),
              ),
              Tab(child: Text('History', style: context.textTheme.labelLarge)),
            ],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  context.colorExtension.outlinedBorder ?? Colors.transparent,
            ),
          ),
        ),

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

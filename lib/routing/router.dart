import 'package:safuku/main_scaffold.dart';
import 'package:safuku/ui/home/screens/home_screen.dart';
import 'package:safuku/ui/onboard/screens/onboard_currency_screen.dart';
import 'package:safuku/ui/onboard/screens/onboard_language_screen.dart';
import 'package:safuku/ui/reports/screens/report_screen.dart';
import 'package:safuku/ui/settings/screens/setting_screen.dart';
import 'package:safuku/ui/transactions/screens/add_transaction_screen.dart';
import 'package:safuku/ui/wallet/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => MainScaffold(navigationShell: child),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wallet',
              builder: (context, state) => const WalletScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/report',
              builder: (context, state) => const ReportScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/setting',
              builder: (context, state) => const SettingScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/add-transaction',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/onboard-language',
      builder: (context, state) => const OnboardLanguageScreen(),
    ),
    GoRoute(
      path: '/onboard-currency',
      builder: (context, state) => const OnboardCurrencyScreen(),
    ),
  ],
);

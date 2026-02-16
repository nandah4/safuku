import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:safuku/bindings/main_bindings.dart';
import 'package:safuku/main_scaffold.dart';
import 'package:safuku/middleware/PersonalizationMiddleware.dart';
import 'package:safuku/ui/onboard/screens/onboard_currency_screen.dart';
import 'package:safuku/ui/onboard/screens/onboard_language_screen.dart';
import 'package:safuku/ui/reports/screens/report_screen.dart';
import 'package:safuku/ui/settings/screens/setting_screen.dart';
import 'package:safuku/ui/transactions/bindings/transaction_detail_binding.dart';
import 'package:safuku/ui/transactions/screens/add_transaction_screen.dart';
import 'package:safuku/ui/transactions/screens/transaction_detail_screen.dart';
import 'package:safuku/ui/wallet/bindings/wallet_binding.dart';
import 'package:safuku/ui/wallet/screens/wallet_screen.dart';
import '../ui/transactions/bindings/transaction_binding.dart';

final routerPage = [
  // Public roues
  GetPage(name: '/onboard-language', page: () => const OnboardLanguageScreen()),
  GetPage(name: '/onboard-currency', page: () => const OnboardCurrencyScreen()),

  // Main app shell with bottom nav
  GetPage(
    name: '/',
    page: () => const MainScaffold(),
    binding: MainBinding(),
    middlewares: [PersonalizationMiddleware()],
  ),
  GetPage(
    name: '/wallet',
    page: () => WalletScreen(),
    binding: WalletBinding(),
    middlewares: [PersonalizationMiddleware()],
  ),
  GetPage(
    name: '/report',
    page: () => const ReportScreen(),
    middlewares: [PersonalizationMiddleware()],
  ),
  GetPage(
    name: '/setting',
    page: () => SettingScreen(),
    middlewares: [PersonalizationMiddleware()],
  ),

  // Nested routes
  GetPage(
    name: '/add-transaction',
    binding: TransactionBinding(),
    page: () => AddTransactionScreen(),
    middlewares: [PersonalizationMiddleware()],
  ),
  GetPage(
    name: '/transaction-detail/:id',
    binding: TransactionDetailBinding(),
    page: () => TransactionDetailScreen(),
    middlewares: [PersonalizationMiddleware()],
  ),
];

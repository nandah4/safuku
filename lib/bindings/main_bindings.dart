import 'package:get/get.dart';
import 'package:safuku/ui/home/bindings/home_bindings.dart';
import 'package:safuku/ui/reports/bindings/transaction_reports_binding.dart';
import 'package:safuku/ui/transactions/bindings/transaction_binding.dart';
import 'package:safuku/ui/transactions/bindings/transaction_detail_binding.dart';
import 'package:safuku/ui/wallet/bindings/wallet_binding.dart';
import 'package:safuku/ui/settings/bindings/backup_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    WalletBinding().dependencies();
    TransactionBinding().dependencies();
    HomeBindings().dependencies();

    // Transactions Binding
    TransactionReportsBinding().dependencies();
    TransactionDetailBinding().dependencies();

    // Settings Binding
    SettingBinding().dependencies();
  }
}

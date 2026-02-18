// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get changeLanguageAnytime =>
      'You can change this anytime in settings.';

  @override
  String get chooseCurrency => 'Choose your currency';

  @override
  String get changeCurrencyAnytime =>
      'This will be used for all your transactions.';

  @override
  String get selectCurrencyButton => 'Select Currency';

  @override
  String get hintTextSearchCurrency => 'Search currency';

  @override
  String get continueButton => 'Continue';

  @override
  String get labelIncome => 'Income';

  @override
  String get labelExpense => 'Expense';

  @override
  String get labelCurrentBalance => 'Current Balance';

  @override
  String get recentTransaction => 'Recent Transaction';

  @override
  String get seeAll => 'See All';

  @override
  String get thanLastWeek => 'Than Last Week';

  @override
  String get wallet => 'Wallet';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get addWallet => 'Add Wallet';

  @override
  String get updateWallet => 'Update Wallet';

  @override
  String get amount => 'Amount';

  @override
  String get createWalletButton => 'Create Wallet';

  @override
  String get updateWalletButton => 'Update Wallet';

  @override
  String get walletName => 'Wallet Name';

  @override
  String get walletColor => 'Wallet Color (Optional)';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get transactionDetail => 'Transaction Detail';

  @override
  String get title => 'Title';

  @override
  String get notes => 'Notes';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get writeNotesHere => 'Write your notes here';

  @override
  String get date => 'Date';

  @override
  String get deleteTransactionConfirm =>
      'Are you sure you want to delete this transaction?';

  @override
  String get statistic => 'Statistic';

  @override
  String get history => 'History';

  @override
  String get spendingBreakdown => 'Spending Breakdown';

  @override
  String get weeklyOverview => 'Weekly Overview';

  @override
  String get noDataThisMonth => 'No data for this month';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get total => 'Total';

  @override
  String get averagePerWeek => 'Average / week';

  @override
  String get highest => 'Highest';

  @override
  String get transactions => 'Transactions';

  @override
  String get spending => 'Spending';

  @override
  String get weekly => 'Weekly';

  @override
  String get emptyHistory => 'Empty';

  @override
  String get settings => 'Settings';

  @override
  String get backupRestore => 'Backup and restore';

  @override
  String get removeData => 'Remove Data';

  @override
  String get currency => 'Currency';

  @override
  String get category => 'Category';

  @override
  String get categoryHint => 'Category name';

  @override
  String get buttonCreateCategory => 'Create Category';

  @override
  String get allCategories => 'All Categories';

  @override
  String get valCategoryRequired => 'Category name is required';

  @override
  String get valCategorySpecialChars =>
      'Category name must not contain special characters.';

  @override
  String get walletNameRequired => 'Wallet name is required.';

  @override
  String get walletNameInvalid =>
      'Wallet name can only contain letters and numbers.';

  @override
  String fieldRequired(Object label) {
    return '$label is required.';
  }

  @override
  String get transactionTypeRequired => 'Transaction type is required';

  @override
  String get walletRequired => 'Wallet is required';

  @override
  String get categoryRequired => 'Category is required';

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get amountInvalid => 'Invalid amount';

  @override
  String get amountMustBePositive => 'Amount must be greater than 0';

  @override
  String get transactionDataEmpty => 'Transaction data is empty';

  @override
  String get errorFetchWallets => 'Failed to get wallets';

  @override
  String get errorGeneric => 'Error';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get week => 'Week';

  @override
  String get weekShort => 'W';

  @override
  String get deleteThis => 'Delete this';

  @override
  String get deleteGeneralConfirm => 'Are you sure you want to delete this?';

  @override
  String get deleteWalletConfirm =>
      'Are you sure you want to delete this wallet?';

  @override
  String get bottomHome => 'Home';

  @override
  String get bottomWallet => 'Wallet';

  @override
  String get bottomReports => 'Reports';

  @override
  String get bottomSettings => 'Settings';

  @override
  String get youCanRecordExpensesAndIncome =>
      'You can record expenses and income';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get allTime => 'All Time';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get walletEmpty => 'No wallets found';

  @override
  String get restore => 'Restore';

  @override
  String get backup => 'Backup';

  @override
  String get backupSuccess => 'Backup completed successfully';

  @override
  String get restoreSuccess => 'Restore completed successfully';

  @override
  String get invalidFileFormat => 'Invalid file format';

  @override
  String get delete => 'Delete';

  @override
  String get data => 'Data';

  @override
  String get dataDescription =>
      'Data is stored locally on your device. You can export it to a file and import it back if needed.';

  @override
  String get backupRestoreDescription =>
      'Perform regular backups or restore your old data.';
}

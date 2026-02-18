import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
  ];

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in settings.'**
  String get changeLanguageAnytime;

  /// Title for currency selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose your currency'**
  String get chooseCurrency;

  /// Title for currency selection screen
  ///
  /// In en, this message translates to:
  /// **'This will be used for all your transactions.'**
  String get changeCurrencyAnytime;

  /// Button for currency selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrencyButton;

  /// Hint text for currency search
  ///
  /// In en, this message translates to:
  /// **'Search currency'**
  String get hintTextSearchCurrency;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Label for income
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get labelIncome;

  /// Label for expense
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get labelExpense;

  /// Label for current balance
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get labelCurrentBalance;

  /// Title for recent transaction
  ///
  /// In en, this message translates to:
  /// **'Recent Transaction'**
  String get recentTransaction;

  /// Label for see all
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Label for than last week
  ///
  /// In en, this message translates to:
  /// **'Than Last Week'**
  String get thanLastWeek;

  /// Title for wallet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Label for total amount
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Label for add wallet
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWallet;

  /// Label for update wallet
  ///
  /// In en, this message translates to:
  /// **'Update Wallet'**
  String get updateWallet;

  /// Label for amount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Button for create wallet
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get createWalletButton;

  /// Button for update wallet
  ///
  /// In en, this message translates to:
  /// **'Update Wallet'**
  String get updateWalletButton;

  /// Label for wallet name
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get walletName;

  /// Label for wallet color
  ///
  /// In en, this message translates to:
  /// **'Wallet Color (Optional)'**
  String get walletColor;

  /// Button for pick color
  ///
  /// In en, this message translates to:
  /// **'Pick Color'**
  String get pickColor;

  /// Button for cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button for save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button for close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Button for back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Title for add transaction screen
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// Title for transaction detail screen
  ///
  /// In en, this message translates to:
  /// **'Transaction Detail'**
  String get transactionDetail;

  /// Label for title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Label for notes field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Label for optional notes field
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// Placeholder for notes
  ///
  /// In en, this message translates to:
  /// **'Write your notes here'**
  String get writeNotesHere;

  /// Label for date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Confirmation message for deleting transaction
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteTransactionConfirm;

  /// Title for statistic screen
  ///
  /// In en, this message translates to:
  /// **'Statistic'**
  String get statistic;

  /// Title for history tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Title for spending breakdown section
  ///
  /// In en, this message translates to:
  /// **'Spending Breakdown'**
  String get spendingBreakdown;

  /// Title for weekly overview section
  ///
  /// In en, this message translates to:
  /// **'Weekly Overview'**
  String get weeklyOverview;

  /// Message for empty data in month
  ///
  /// In en, this message translates to:
  /// **'No data for this month'**
  String get noDataThisMonth;

  /// Message for empty transactions list
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// Label for total
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Label for average per week
  ///
  /// In en, this message translates to:
  /// **'Average / week'**
  String get averagePerWeek;

  /// Label for highest value
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// Label for transactions count
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Label for spending tab
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get spending;

  /// Label for weekly tab
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Message for empty history
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyHistory;

  /// Title for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for backup and restore option
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get backupRestore;

  /// Label for remove data option
  ///
  /// In en, this message translates to:
  /// **'Remove Data'**
  String get removeData;

  /// Label for currency setting
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Category title
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Hint for category field
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryHint;

  /// Button for create category
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get buttonCreateCategory;

  /// Title for All Categories
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// Validation category required
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get valCategoryRequired;

  /// Validation category special characters
  ///
  /// In en, this message translates to:
  /// **'Category name must not contain special characters.'**
  String get valCategorySpecialChars;

  /// Validation error for wallet name
  ///
  /// In en, this message translates to:
  /// **'Wallet name is required.'**
  String get walletNameRequired;

  /// Validation error for wallet name format
  ///
  /// In en, this message translates to:
  /// **'Wallet name can only contain letters and numbers.'**
  String get walletNameInvalid;

  /// Generic validation error with parameter
  ///
  /// In en, this message translates to:
  /// **'{label} is required.'**
  String fieldRequired(Object label);

  /// Validation error for transaction type
  ///
  /// In en, this message translates to:
  /// **'Transaction type is required'**
  String get transactionTypeRequired;

  /// Validation error for wallet selection
  ///
  /// In en, this message translates to:
  /// **'Wallet is required'**
  String get walletRequired;

  /// Validation error for category selection
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get categoryRequired;

  /// Validation error - amount required
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// Validation error for amount
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get amountInvalid;

  /// Validation error for amount greater than 0
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amountMustBePositive;

  /// Error message for empty transaction data
  ///
  /// In en, this message translates to:
  /// **'Transaction data is empty'**
  String get transactionDataEmpty;

  /// Error message for fetching wallets
  ///
  /// In en, this message translates to:
  /// **'Failed to get wallets'**
  String get errorFetchWallets;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// Title for transaction history
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// Label for week
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Short label for week
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekShort;

  /// Delete this
  ///
  /// In en, this message translates to:
  /// **'Delete this'**
  String get deleteThis;

  /// Confirmation message for deleting wallet
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get deleteGeneralConfirm;

  /// Confirmation message for deleting wallet
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this wallet?'**
  String get deleteWalletConfirm;

  /// Bottom navigation title for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomHome;

  /// Bottom navigation title for wallet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get bottomWallet;

  /// Bottom navigation title for reports
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get bottomReports;

  /// Bottom navigation title for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bottomSettings;

  /// You can record expenses and income
  ///
  /// In en, this message translates to:
  /// **'You can record expenses and income'**
  String get youCanRecordExpensesAndIncome;

  /// Transaction Type
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// All time label
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// Something went wrong
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No wallets found
  ///
  /// In en, this message translates to:
  /// **'No wallets found'**
  String get walletEmpty;

  /// Restore label
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Backup label
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Backup success message
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully'**
  String get backupSuccess;

  /// Restore success message
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully'**
  String get restoreSuccess;

  /// Invalid file format error
  ///
  /// In en, this message translates to:
  /// **'Invalid file format'**
  String get invalidFileFormat;

  /// Delete label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Data label
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Data description
  ///
  /// In en, this message translates to:
  /// **'Data is stored locally on your device. You can export it to a file and import it back if needed.'**
  String get dataDescription;

  /// Description for backup and restore section
  ///
  /// In en, this message translates to:
  /// **'Perform regular backups or restore your old data.'**
  String get backupRestoreDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get language => '言語';

  @override
  String get chooseLanguage => '言語を選択';

  @override
  String get changeLanguageAnytime => '設定でいつでも変更できます。';

  @override
  String get chooseCurrency => '通貨を選択';

  @override
  String get changeCurrencyAnytime => 'これはすべての取引に使用されます。';

  @override
  String get selectCurrencyButton => '通貨を選択';

  @override
  String get hintTextSearchCurrency => '通貨を検索';

  @override
  String get continueButton => '次へ';

  @override
  String get labelIncome => '収入';

  @override
  String get labelExpense => '支出';

  @override
  String get labelCurrentBalance => '現在の残高';

  @override
  String get recentTransaction => '最近の取引';

  @override
  String get seeAll => 'すべて見る';

  @override
  String get thanLastWeek => '先週比';

  @override
  String get wallet => 'ウォレット';

  @override
  String get totalAmount => '合計金額';

  @override
  String get addWallet => 'ウォレットを追加';

  @override
  String get updateWallet => 'ウォレットを更新';

  @override
  String get amount => '金額';

  @override
  String get createWalletButton => 'ウォレットを作成';

  @override
  String get updateWalletButton => 'ウォレットを更新';

  @override
  String get walletName => 'ウォレット名';

  @override
  String get walletColor => 'ウォレットの色（任意）';

  @override
  String get pickColor => '色を選択';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get close => '閉じる';

  @override
  String get back => '戻る';

  @override
  String get addTransaction => '取引を追加';

  @override
  String get transactionDetail => '取引詳細';

  @override
  String get title => 'タイトル';

  @override
  String get notes => 'メモ';

  @override
  String get notesOptional => 'メモ（任意）';

  @override
  String get writeNotesHere => 'ここにメモを書く';

  @override
  String get date => '日付';

  @override
  String get deleteTransactionConfirm => '本当にこの取引を削除しますか？';

  @override
  String get statistic => '統計';

  @override
  String get history => '履歴';

  @override
  String get spendingBreakdown => '支出の内訳';

  @override
  String get weeklyOverview => '週間概要';

  @override
  String get noDataThisMonth => '今月のデータはありません';

  @override
  String get noTransactionsYet => '取引はまだありません';

  @override
  String get total => '合計';

  @override
  String get averagePerWeek => '平均 / 週';

  @override
  String get highest => '最高';

  @override
  String get transactions => '取引';

  @override
  String get spending => '支出';

  @override
  String get weekly => '週間';

  @override
  String get emptyHistory => '空';

  @override
  String get settings => '設定';

  @override
  String get backupRestore => 'バックアップと復元';

  @override
  String get removeData => 'データを削除';

  @override
  String get currency => '通貨';

  @override
  String get category => 'カテゴリー';

  @override
  String get categoryHint => 'カテゴリー名';

  @override
  String get buttonCreateCategory => 'カテゴリーを作成';

  @override
  String get allCategories => 'すべてのカテゴリー';

  @override
  String get valCategoryRequired => 'カテゴリー名は必須です';

  @override
  String get valCategorySpecialChars => 'カテゴリー名に特殊文字を含めることはできません。';

  @override
  String get walletNameRequired => 'ウォレット名は必須です。';

  @override
  String get walletNameInvalid => 'ウォレット名は文字と数字のみ使用できます。';

  @override
  String fieldRequired(Object label) {
    return '$label は必須です。';
  }

  @override
  String get transactionTypeRequired => '取引タイプは必須です';

  @override
  String get walletRequired => 'ウォレットは必須です';

  @override
  String get categoryRequired => 'カテゴリーは必須です';

  @override
  String get amountRequired => '金額は必須です';

  @override
  String get amountInvalid => '無効な金額です';

  @override
  String get amountMustBePositive => '金額は0より大きい必要があります';

  @override
  String get transactionDataEmpty => '取引データが空です';

  @override
  String get errorFetchWallets => 'ウォレットの取得に失敗しました';

  @override
  String get errorGeneric => 'エラー';

  @override
  String get transactionHistory => '取引履歴';

  @override
  String get week => '週';

  @override
  String get weekShort => '週';

  @override
  String get deleteThis => 'これを削除';

  @override
  String get deleteGeneralConfirm => '本当にこれを削除しますか？';

  @override
  String get deleteWalletConfirm => '本当にこのウォレットを削除しますか？';

  @override
  String get bottomHome => 'ホーム';

  @override
  String get bottomWallet => 'ウォレット';

  @override
  String get bottomReports => 'レポート';

  @override
  String get bottomSettings => '設定';

  @override
  String get youCanRecordExpensesAndIncome => '支出と収入を記録できます';

  @override
  String get transactionType => '取引タイプ';

  @override
  String get allTime => '全期間';

  @override
  String get somethingWentWrong => '問題が発生しました';

  @override
  String get walletEmpty => 'ウォレットが見つかりません';

  @override
  String get restore => '復元';

  @override
  String get backup => 'バックアップ';

  @override
  String get backupSuccess => 'バックアップが完了しました';

  @override
  String get restoreSuccess => '復元が完了しました';

  @override
  String get invalidFileFormat => '無効なファイル形式';

  @override
  String get delete => '削除';

  @override
  String get data => 'データ';

  @override
  String get dataDescription =>
      'データは端末にローカル保存されます。必要に応じてファイルにエクスポートしたり、インポートし直すことができます。';

  @override
  String get backupRestoreDescription => '定期的にバックアップを行うか、古いデータを復元してください。';
}

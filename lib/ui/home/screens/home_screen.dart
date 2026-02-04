import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/transaction_card_widget.dart';
import 'package:safuku/ui/home/widgets/wallet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class RecentTransaction {
  final String title;
  final String category;
  final String amount;
  final DateTime date;
  final String wallet;
  final String detail;
  final String type;

  RecentTransaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.wallet,
    required this.detail,
    required this.type,
  });
}

final recentTransactions = [
  RecentTransaction(
    title: "Shopping",
    category: "Groceries",
    amount: "Rp 100.000",
    date: DateTime.now(),
    wallet: "BCA",
    detail: "Beli Kebutuhan Sehari-hari",
    type: "expense",
  ),
  RecentTransaction(
    title: "Shopping",
    category: "Groceries",
    amount: "Rp 100.000",
    date: DateTime.now(),
    wallet: "BCA",
    detail: "Beli Kebutuhan Sehari-hari",
    type: "expense",
  ),
  RecentTransaction(
    title: "Shopping",
    category: "Groceries",
    amount: "Rp 100.000",
    date: DateTime.now(),
    wallet: "BCA",
    detail: "Beli Kebutuhan Sehari-hari",
    type: "expense",
  ),

  RecentTransaction(
    title: "Gaji",
    category: "Salary",
    amount: "Rp 600.000",
    date: DateTime.now(),
    wallet: "BCA",
    detail: "Gaji Bulan Ini",
    type: "income",
  ),
  RecentTransaction(
    title: "Gaji",
    category: "Salary",
    amount: "Rp 600.000",
    date: DateTime.now(),
    wallet: "BCA",
    detail: "Gaji Bulan Ini",
    type: "income",
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDate;
  bool _isBalanceVisible = true;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollController.offset > 20
          ? setState(() => _isScrolled = true)
          : setState(() => _isScrolled = false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showMonthPicker(
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: PickerDialogSettings(
          dialogBackgroundColor: context.colorScheme.surface,
          insetPadding: EdgeInsets.all(PaddingScale.lg),
        ),
        headerSettings: PickerHeaderSettings(
          headerBackgroundColor: AppColors.primary,
          nextIcon: FontAwesomeIcons.arrowRight,
          previousIcon: FontAwesomeIcons.arrowLeft,
          headerIconsSize: IconSizeScale.sm,
          headerIconsColor: AppColors.text,
          headerCurrentPageTextStyle: context.textTheme.headlineSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          headerSelectedIntervalTextStyle: context.textTheme.labelLarge
              ?.copyWith(color: AppColors.text),
        ),
        actionBarSettings: PickerActionBarSettings(
          actionBarPadding: .symmetric(
            horizontal: PaddingScale.lg,
            vertical: PaddingScale.md,
          ),
          buttonSpacing: SpacingScale.sm,
          confirmWidget: Text("Confirm", style: context.textTheme.labelLarge),
          cancelWidget: Text("Cancel", style: context.textTheme.labelLarge),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          unselectedMonthsTextColor: context.colorExtension.unselectedTextColor,
          selectedMonthBackgroundColor: context.colorExtension.buttonMuted,
        ),
      ),
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(9000),
      initialDate: DateTime.now(),
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  String get _selectedDateString =>
      DateFormat("MMMM yyyy").format(_selectedDate ?? DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: context.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: _isScrolled
              ? context.colorScheme.surface
              : Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,

          title: GestureDetector(
            onTap: () {
              _selectDate();
            },
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidCalendar,
                  size: IconSizeScale.md,
                  color: _isScrolled ? AppColors.primary : AppColors.text,
                ),
                const SizedBox(width: SpacingScale.sm),
                Text(
                  _selectedDateString,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: _isScrolled
                        ? context.colorExtension.textLabel
                        : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 295,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: .75),
                        AppColors.primary,
                      ],
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  minimum: EdgeInsets.symmetric(horizontal: PaddingScale.lg),
                  child: Column(
                    children: [
                      const SizedBox(height: SpacingScale.lg),
                      // Total Balance
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Current Balance",
                              style: context.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isBalanceVisible
                                      ? "\$ 100.000.000,00"
                                      : "*******",
                                  style: context.textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: SpacingScale.xs),
                                IconButton(
                                  onPressed: () {
                                    setState(
                                      () => _isBalanceVisible =
                                          !_isBalanceVisible,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_rounded,
                                    color: Colors.white,
                                    size: IconSizeScale.sm,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SpacingScale.md),
                            Text(
                              "- 0,80 %  Than last week",
                              style: context.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: SpacingScale.xl * 2),
                            Row(
                              children: [
                                Expanded(
                                  child: WalletCardWidget(
                                    balance: "IDR 100.000,00",
                                    color: AppColors.success,
                                    icon: FontAwesomeIcons.wallet,
                                    title: "Income",
                                  ),
                                ),
                                const SizedBox(width: SpacingScale.sm),
                                Expanded(
                                  child: WalletCardWidget(
                                    balance: "IDR 100.000,00",
                                    color: AppColors.error,
                                    icon: FontAwesomeIcons.wallet,
                                    title: "Expenses",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingScale.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PaddingScale.lg),
              child: Column(
                mainAxisSize: .min,
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Recent Transactions",
                        style: context.textTheme.titleSmall,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See All",
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingScale.sm),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: .only(bottom: PaddingScale.lg, top: 0),
                    itemCount: recentTransactions.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TransactionCardWidget(
                        icon: FontAwesomeIcons.moneyBill,
                        type: recentTransactions[index].type,
                        title: recentTransactions[index].title,
                        detail: recentTransactions[index].detail,
                        amount: recentTransactions[index].amount,
                        date: recentTransactions[index].date,
                        wallet: recentTransactions[index].wallet,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: SpacingScale.sm),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

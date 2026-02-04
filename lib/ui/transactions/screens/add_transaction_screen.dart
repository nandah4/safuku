import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/action_tile.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:safuku/ui/core/ui/text_form_custom.dart';
import 'package:safuku/ui/transactions/widgets/add_category_widget.dart';

final List<Map<String, dynamic>> walletList = [
  {"id": "1", "name": "Wallet 1", "color": "FF0000"},
  {"id": "2", "name": "Wallet 2", "color": "00FF00"},
  {"id": "3", "name": "Wallet 3", "color": "0000FF"},
  {"id": "4", "name": "Wallet 4", "color": "0000FF"},
  {"id": "5", "name": "Wallet 5", "color": "0000FF"},
  {"id": "6", "name": "Wallet 6", "color": "0000FF"},
  {"id": "7", "name": "Wallet 7", "color": "0000FF"},
  {"id": "8", "name": "Wallet 8", "color": "0000FF"},
  {"id": "9", "name": "Wallet 9", "color": "0000FF"},
  {"id": "10", "name": "Wallet 10", "color": "0000FF"},
];

final List<Map<String, dynamic>> categoryList = [
  {"id": "1", "name": "Category 1"},
  {"id": "2", "name": "Category 2"},
  {"id": "3", "name": "Category 3"},
  {"id": "4", "name": "Category 4"},
  {"id": "5", "name": "Category 5"},
];

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController amountController;
  late TextEditingController nameController;
  late TextEditingController notesController;

  String? transactionType;
  String? walletId;
  String? categoryId;
  DateTime? _selectedDate = DateTime.now();
  String? notes;

  String? _amountError;
  String? _walletError;
  String? _transactionTypeError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    nameController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        okButton: Text(
          "Confirm",
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorExtension.textPrimary,
          ),
        ),
        cancelButton: Text("Cancel", style: context.textTheme.labelLarge),
      ),
      dialogSize: const Size(325, 400),
      value: [_selectedDate],
      borderRadius: BorderRadius.circular(15),
      dialogBackgroundColor: context.colorScheme.surface,
      useSafeArea: true,
    );

    if (picked != null) setState(() => _selectedDate = picked.first);
  }

  String get _formattedDate =>
      DateFormat("dd MMMM yyyy").format(_selectedDate ?? DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(FontAwesomeIcons.chevronLeft, size: IconSizeScale.sm),
          ),
          centerTitle: false,
          title: Text("Add Transaction", style: context.textTheme.titleLarge),
          surfaceTintColor: context.colorScheme.surface,
          backgroundColor: context.colorScheme.surface,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: .vertical,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    // Amount
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: Container(
                        width: double.infinity,
                        padding: .symmetric(
                          horizontal: PaddingScale.xl,
                          vertical: PaddingScale.xl * 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorExtension.bgCard,
                          borderRadius: .circular(BorderRadiusScale.sm),
                          border: Border.all(
                            color: _amountError != null
                                ? AppColors.error
                                : context.colorExtension.outlinedBorder ??
                                      AppColors.outlinedBorderLight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: .center,
                          children: [
                            Text(
                              "Amount",
                              style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: SpacingScale.xs),
                            TextFormField(
                              keyboardType: .number,
                              autofocus: true,
                              onChanged: (value) {
                                if (_amountError != null) {
                                  setState(() => _amountError = null);
                                }
                              },

                              textAlign: .center,
                              controller: amountController,
                              style: context.textStyleExtension.currencyLarge,
                              decoration: InputDecoration(
                                errorStyle: context.textTheme.labelLarge
                                    ?.copyWith(
                                      color: context.colorScheme.error,
                                    ),
                                border: .none,
                                enabledBorder: .none,
                                focusedBorder: .none,
                                disabledBorder: .none,
                                hintText: "0",
                                hintStyle:
                                    context.textStyleExtension.currencyLarge,
                              ),
                            ),
                            if (_amountError != null) ...[
                              const SizedBox(height: SpacingScale.md),
                              Text(
                                _amountError!,
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: SpacingScale.xl),

                    // Transaction Type
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Transaction Type",
                            style: context.textTheme.titleSmall,
                          ),
                          const SizedBox(height: SpacingScale.sm),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => transactionType = "income");
                                    setState(
                                      () => _transactionTypeError = null,
                                    );
                                  },
                                  child: Container(
                                    padding: .symmetric(
                                      horizontal: PaddingScale.xl,
                                      vertical: PaddingScale.lg,
                                    ),
                                    decoration: BoxDecoration(
                                      color: transactionType == "income"
                                          ? AppColors.successBackground
                                          : context.colorExtension.bgCard,
                                      borderRadius: .circular(
                                        BorderRadiusScale.sm,
                                      ),
                                      border: Border.all(
                                        color:
                                            context
                                                .colorExtension
                                                .outlinedBorder ??
                                            AppColors.outlinedBorderLight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Income",
                                        style: context.textTheme.titleSmall
                                            ?.copyWith(
                                              color: transactionType == "income"
                                                  ? AppColors.success
                                                  : context
                                                        .colorExtension
                                                        .textPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: SpacingScale.md),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => transactionType = "expense");
                                    setState(
                                      () => _transactionTypeError = null,
                                    );
                                  },
                                  child: Container(
                                    padding: .symmetric(
                                      horizontal: PaddingScale.xl,
                                      vertical: PaddingScale.lg,
                                    ),
                                    decoration: BoxDecoration(
                                      color: transactionType == "expense"
                                          ? AppColors.errorBackground
                                          : context.colorExtension.bgCard,
                                      borderRadius: .circular(
                                        BorderRadiusScale.sm,
                                      ),
                                      border: Border.all(
                                        color:
                                            context
                                                .colorExtension
                                                .outlinedBorder ??
                                            AppColors.outlinedBorderLight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Expense",
                                        style: context.textTheme.titleSmall
                                            ?.copyWith(
                                              color:
                                                  transactionType == "expense"
                                                  ? AppColors.error
                                                  : context
                                                        .colorExtension
                                                        .textPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_transactionTypeError != null) ...[
                            const SizedBox(height: SpacingScale.sm),
                            Text(
                              _transactionTypeError!,
                              style: context.textTheme.labelMedium?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: SpacingScale.lg),

                    // Wallet
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Wallet", style: context.textTheme.titleSmall),
                          const SizedBox(height: SpacingScale.sm),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: MediaQuery.removePadding(
                        removeLeft: true,
                        removeRight: true,
                        context: context,
                        child: ListView.separated(
                          padding: .symmetric(horizontal: PaddingScale.lg),
                          scrollDirection: .horizontal,

                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  walletId = walletList[index]["id"];
                                });
                                setState(() => _walletError = null);
                              },
                              child: Container(
                                padding: .symmetric(
                                  horizontal: PaddingScale.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorExtension.bgCard,
                                  borderRadius: BorderRadius.circular(
                                    BorderRadiusScale.sm,
                                  ),
                                  border: Border.all(
                                    width: walletId == walletList[index]["id"]
                                        ? 2
                                        : 1,
                                    color: walletId == walletList[index]["id"]
                                        ? AppColors.primary
                                        : context
                                                  .colorExtension
                                                  .outlinedBorder ??
                                              AppColors.outlinedBorderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.wallet,
                                      size: IconSizeScale.sm,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: SpacingScale.md),
                                    Text(
                                      walletList[index]["name"],
                                      style: context.textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: SpacingScale.md);
                          },
                          itemCount: walletList.length,
                        ),
                      ),
                    ),
                    if (_walletError != null) ...[
                      const SizedBox(height: SpacingScale.sm),
                      Padding(
                        padding: .symmetric(horizontal: PaddingScale.lg),
                        child: Text(
                          _walletError!,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: SpacingScale.lg),

                    // Category
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Category", style: context.textTheme.titleSmall),
                          const SizedBox(height: SpacingScale.sm),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        padding: .symmetric(horizontal: PaddingScale.lg),
                        scrollDirection: .horizontal,

                        itemBuilder: (context, index) {
                          if (index < 2) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  categoryId = categoryList[index]["id"];
                                });
                                setState(() => _categoryError = null);
                              },
                              child: Container(
                                padding: .symmetric(
                                  horizontal: PaddingScale.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorExtension.bgCard,
                                  borderRadius: BorderRadius.circular(
                                    BorderRadiusScale.sm,
                                  ),
                                  border: Border.all(
                                    width:
                                        categoryId == categoryList[index]["id"]
                                        ? 2
                                        : 1,
                                    color:
                                        categoryId == categoryList[index]["id"]
                                        ? AppColors.primary
                                        : context
                                                  .colorExtension
                                                  .outlinedBorder ??
                                              AppColors.outlinedBorderLight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    categoryList[index]["name"],
                                    style: context.textTheme.labelMedium,
                                  ),
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  maxHeight: context.screenSize.height * 0.92,
                                ),
                                builder: (context) {
                                  return AddCategoryWidget(
                                    categoryId: categoryId,
                                    onCategorySelected: (id) {
                                      print("Category ID: $id");
                                      setState(() => categoryId = id);
                                      setState(() => _categoryError = null);
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: .symmetric(horizontal: PaddingScale.lg),
                              decoration: BoxDecoration(
                                color: context.colorExtension.bgCard,
                                borderRadius: BorderRadius.circular(
                                  BorderRadiusScale.sm,
                                ),
                                border: Border.all(
                                  width: 1,
                                  color:
                                      context.colorExtension.outlinedBorder ??
                                      AppColors.outlinedBorderLight,
                                ),
                              ),
                              child: Center(child: Icon(Icons.add)),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(width: SpacingScale.md);
                        },
                        itemCount: categoryList.length > 2
                            ? 3
                            : categoryList.length,
                      ),
                    ),
                    if (_categoryError != null) ...[
                      const SizedBox(height: SpacingScale.sm),
                      Padding(
                        padding: .symmetric(horizontal: PaddingScale.lg),
                        child: Text(
                          _categoryError!,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: SpacingScale.lg),

                    // Title
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextFormCustom(
                            icon: Icons.title,
                            controller: nameController,
                            iconColor: AppColors.primary,
                            labelText: "Title",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SpacingScale.lg),

                    // Date
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          ActionTile(
                            onTap: () => _selectDate(),
                            icon: Icons.calendar_today,
                            label: _formattedDate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SpacingScale.lg),

                    // Notes
                    Padding(
                      padding: .symmetric(horizontal: PaddingScale.lg),
                      child: TextFormField(
                        controller: notesController,
                        keyboardType: .multiline,
                        maxLines: 4,

                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  context.colorExtension.outlinedBorder ??
                                  AppColors.outlinedBorderLight,
                            ),
                            borderRadius: BorderRadius.circular(
                              BorderRadiusScale.sm,
                            ),
                          ),
                          filled: true,
                          fillColor: context.colorExtension.bgCard,
                          alignLabelWithHint: true,
                          labelText: "Notes (optional)",
                          labelStyle: context.textTheme.labelLarge,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              BorderRadiusScale.sm,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SpacingScale.xl),

                Padding(
                  padding: .symmetric(horizontal: PaddingScale.lg),
                  child: ButtonPrimary(
                    text: "Add Transaction",
                    onPressed: () {
                      if (amountController.text.isEmpty) {
                        setState(() => _amountError = "Amount is required");
                      }
                      if (transactionType == null) {
                        setState(
                          () => _transactionTypeError =
                              "Transaction type is required",
                        );
                      }
                      if (walletId == null) {
                        setState(() => _walletError = "Wallet is required");
                      }
                      if (categoryId == null) {
                        setState(() => _categoryError = "Category is required");
                      }

                      if (_formKey.currentState!.validate()) {
                        print(notesController.text.trim());
                        context.pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:safuku/ui/transactions/screens/add_transaction_screen.dart';

class AddCategoryWidget extends StatefulWidget {
  final String? categoryId;
  final Function(String) onCategorySelected;
  const AddCategoryWidget({
    super.key,
    required this.categoryId,
    required this.onCategorySelected,
  });

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController categoryNameController;
  late String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    categoryNameController = TextEditingController();
    _selectedCategoryId = widget.categoryId;
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: .vertical(top: Radius.circular(BorderRadiusScale.lg)),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,

        children: [
          // Header
          Padding(
            padding: .only(
              left: PaddingScale.lg,
              right: PaddingScale.lg,
              top: PaddingScale.sm,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    FontAwesomeIcons.chevronLeft,
                    size: IconSizeScale.sm,
                  ),
                ),
                const SizedBox(width: SpacingScale.sm),
                Text("Category ", style: context.textTheme.titleMedium),
              ],
            ),
          ),
          Divider(color: context.colorExtension.outlinedBorder),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .vertical,
              padding: .symmetric(
                horizontal: PaddingScale.lg,
                vertical: PaddingScale.md,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    TextFormField(
                      controller: categoryNameController,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorExtension.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colorExtension.bgCard,
                        label: Text(
                          "Category",
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.tag,
                          size: IconSizeScale.md,
                          color: context.colorScheme.primary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(
                            color:
                                context.colorExtension.outlinedBorder ??
                                AppColors.outlinedBorderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(
                            color:
                                context.colorExtension.outlinedBorder ??
                                AppColors.outlinedBorderLight,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(color: AppColors.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusScale.sm,
                          ),
                          borderSide: BorderSide(color: AppColors.error),
                        ),
                        errorStyle: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Category name is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: SpacingScale.xl),
                    ButtonPrimary(
                      text: "Create Category",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                    ),
                    const SizedBox(height: SpacingScale.xl),

                    // All Categories
                    Text("All Categories", style: context.textTheme.titleSmall),
                    const SizedBox(height: SpacingScale.sm),
                    Wrap(
                      spacing: SpacingScale.sm,
                      runSpacing: SpacingScale.sm,
                      children: [
                        ...categoryList.map((category) {
                          return GestureDetector(
                            onTap: () => {
                              widget.onCategorySelected(category["id"]),
                              setState(
                                () => _selectedCategoryId = category["id"],
                              ),
                              context.pop(),
                            },

                            child: SizedBox(
                              child: Container(
                                padding: .symmetric(
                                  horizontal: PaddingScale.lg,
                                  vertical: PaddingScale.lg,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorExtension.bgCard,
                                  borderRadius: BorderRadius.circular(
                                    BorderRadiusScale.sm,
                                  ),
                                  border: Border.all(
                                    width: _selectedCategoryId == category["id"]
                                        ? 2
                                        : 1,
                                    color: _selectedCategoryId == category["id"]
                                        ? AppColors.primary
                                        : context
                                                  .colorExtension
                                                  .outlinedBorder ??
                                              AppColors.outlinedBorderLight,
                                  ),
                                ),
                                child: Text(
                                  category["name"],
                                  style: context.textTheme.labelMedium,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    // SizedBox(
                    //   height: 50,
                    //   child: ListView.separated(
                    //     padding: .symmetric(horizontal: PaddingScale.lg),
                    //     scrollDirection: .horizontal,

                    //     itemBuilder: (context, index) {
                    //       return GestureDetector(
                    //         onTap: () => {
                    //           widget.onCategorySelected(
                    //             categoryList[index]["id"],
                    //           ),
                    //           setState(
                    //             () => _selectedCategoryId =
                    //                 categoryList[index]["id"],
                    //           ),
                    //           context.pop(),
                    //         },

                    //         child: Container(
                    //           padding: .symmetric(horizontal: PaddingScale.lg),
                    //           decoration: BoxDecoration(
                    //             color: context.colorExtension.bgCard,
                    //             borderRadius: BorderRadius.circular(
                    //               BorderRadiusScale.sm,
                    //             ),
                    //             border: Border.all(
                    //               width:
                    //                   _selectedCategoryId ==
                    //                       categoryList[index]["id"]
                    //                   ? 2
                    //                   : 1,
                    //               color:
                    //                   _selectedCategoryId ==
                    //                       categoryList[index]["id"]
                    //                   ? AppColors.primary
                    //                   : context.colorExtension.outlinedBorder ??
                    //                         AppColors.outlinedBorderLight,
                    //             ),
                    //           ),
                    //           child: Center(
                    //             child: Text(
                    //               categoryList[index]["name"],
                    //               style: context.textTheme.labelLarge,
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     separatorBuilder: (context, index) {
                    //       return SizedBox(width: SpacingScale.md);
                    //     },
                    //     itemCount: categoryList.length,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:safuku/ui/core/controllers/personalization_controller.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:flutter/material.dart';

class OnboardLanguageScreen extends StatefulWidget {
  const OnboardLanguageScreen({super.key});

  @override
  State<OnboardLanguageScreen> createState() => _OnboardLanguageScreenState();
}

class _OnboardLanguageScreenState extends State<OnboardLanguageScreen> {
  late final ScrollController _scrollController;
  String? _selectedLanguage;
  bool _isSliverAppBarPinned = false;

  final personalizationController = Get.find<PersonalizationController>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      _scrollController.offset > 180
          ? setState(() => _isSliverAppBarPinned = true)
          : setState(() => _isSliverAppBarPinned = false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,

            toolbarHeight: _isSliverAppBarPinned ? kToolbarHeight : 0,
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: context.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: _isSliverAppBarPinned
                  ? Text(
                      context.localizations.language,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    )
                  : null,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: .symmetric(horizontal: PaddingScale.lg),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/onboard-asset-language.png',
                      width: ImageSizeScale.onboard,
                    ),
                  ),
                  const SizedBox(height: SpacingScale.sm),
                  Text(
                    context.localizations.chooseLanguage,
                    style: context.textTheme.bodyMedium?.copyWith(height: 1),
                  ),
                  const SizedBox(height: SpacingScale.sm),
                  SizedBox(
                    width: context.screenSize.width * .85,
                    child: Text(
                      textAlign: .center,
                      context.localizations.changeLanguageAnytime,
                      style: context.textTheme.bodySmall?.copyWith(height: 1.2),
                    ),
                  ),
                  const SizedBox(height: SpacingScale.xl),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: .symmetric(horizontal: PaddingScale.lg),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: SpacingScale.xl,
                crossAxisSpacing: SpacingScale.xl,
              ),

              itemCount: personalizationController.languageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLanguage =
                          personalizationController.languageList[index].id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SpacingScale.lg * 2),
                      border: Border.all(
                        color:
                            _selectedLanguage ==
                                personalizationController.languageList[index].id
                            ? context.colorScheme.outline
                            : Colors.transparent,
                      ),
                      gradient:
                          _selectedLanguage ==
                              personalizationController.languageList[index].id
                          ? LinearGradient(
                              colors: [
                                AppColors.gradientPrimaryStart,
                                AppColors.primary,
                              ],
                              begin: .topCenter,
                              end: .bottomCenter,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        Text(
                          personalizationController
                              .languageList[index]
                              .flagIcon,
                          style: context.textTheme.bodyMedium?.copyWith(
                            height: 1,
                            fontSize: IconSizeScale.xl,
                          ),
                        ),
                        const SizedBox(height: SpacingScale.sm),
                        Text(
                          personalizationController.languageList[index].name,
                          textAlign: .center,
                          style: context.textTheme.labelMedium?.copyWith(
                            color:
                                _selectedLanguage ==
                                    personalizationController
                                        .languageList[index]
                                        .id
                                ? Colors.white
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: .symmetric(horizontal: PaddingScale.lg),
        child: ButtonPrimary(
          text: context.localizations.continueButton,
          isDisabled: _selectedLanguage == null,
          onPressed: () {
            if (_selectedLanguage != null) {
              personalizationController.setLocale(_selectedLanguage!);
              Get.updateLocale(Locale(_selectedLanguage!));
              Get.toNamed('/onboard-currency');
            }
          },
        ),
      ),
    );
  }
}

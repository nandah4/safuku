import 'package:safuku/data/models/language_model.dart';
import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/app_dimens.dart';
import 'package:safuku/ui/core/themes/extensions/theme_extension.dart';
import 'package:safuku/ui/core/ui/button_primary.dart';
import 'package:safuku/ui/onboard/screens/onboard_currency_screen.dart';
import 'package:flutter/material.dart';

final languageList = [
  Language(id: 'id', name: 'Indonesia', flagIcon: '🇮🇩'),
  Language(id: 'en', name: 'English', flagIcon: '🇬🇧'),
  Language(id: 'jp', name: 'Japanese', flagIcon: '🇯🇵'),
  Language(id: 'my', name: 'Malaysia', flagIcon: '🇲🇾'),
  Language(id: 'sg', name: 'Singapore', flagIcon: '🇸🇬'),
  Language(id: 'bn', name: 'Brunei', flagIcon: '🇧🇳'),
  Language(id: 'tl', name: 'Timor Leste', flagIcon: '🇹🇱'),
  Language(id: 'ph', name: 'Philippines', flagIcon: '🇵🇭'),
  Language(id: 'th', name: 'Thailand', flagIcon: '🇹🇭'),
  Language(id: 'vn', name: 'Vietnam', flagIcon: '🇻🇳'),
  Language(id: 'kh', name: 'Cambodia', flagIcon: '🇰🇭'),
  Language(id: 'la', name: 'Laos', flagIcon: '🇱🇦'),
  Language(id: 'mm', name: 'Myanmar', flagIcon: '🇲🇲'),
  Language(id: 'cn', name: 'China', flagIcon: '🇨🇳'),
  Language(id: 'tw', name: 'Taiwan', flagIcon: '🇹🇼'),
  Language(id: 'kr', name: 'South Korea', flagIcon: '🇰🇷'),
  Language(id: 'au', name: 'Australia', flagIcon: '🇦🇺'),
  Language(id: 'nz', name: 'New Zealand', flagIcon: '🇳🇿'),
  Language(id: 'as', name: 'America Serikat', flagIcon: '🇺🇸'),
  Language(id: 'ar', name: 'Arab Saudi', flagIcon: '🇸🇦'),
  Language(id: 'ae', name: 'Uni Emirat Arab', flagIcon: '🇦🇪'),
  Language(id: "hk", name: "Hong Kong", flagIcon: "🇭🇰"),
  Language(id: "blnd", name: "Belanda", flagIcon: "🇳🇱"),
  Language(id: "frnch", name: "Prancis", flagIcon: "🇫🇷"),
  Language(id: "de", name: "Jerman", flagIcon: "🇩🇪"),
  Language(id: "es", name: "Spanyol", flagIcon: "🇪🇸"),
  Language(id: "it", name: "Italia", flagIcon: "🇮🇹"),
  Language(id: "ru", name: "Rusia", flagIcon: "🇷🇺"),
  Language(id: "tr", name: "Turki", flagIcon: "🇹🇷"),
  Language(id: "grk", name: "Yunani", flagIcon: "🇬🇷"),
  Language(id: "pl", name: "Polandia", flagIcon: "🇵🇱"),
  Language(id: "cz", name: "Ceko", flagIcon: "🇨🇿"),
  Language(id: "hu", name: "Hungaria", flagIcon: "🇭🇺"),
  Language(id: "fi", name: "Finlandia", flagIcon: "🇫🇮"),
  Language(id: "no", name: "Norwegia", flagIcon: "🇳🇴"),
  Language(id: "se", name: "Swedia", flagIcon: "🇸🇪"),
  Language(id: "dk", name: "Denmark", flagIcon: "🇩🇰"),
  Language(id: "ch", name: "Swiss", flagIcon: "🇨🇭"),
  Language(id: "at", name: "Austria", flagIcon: "🇦🇹"),
  Language(id: "be", name: "Belgia", flagIcon: "🇧🇪"),
  Language(id: "ie", name: "Irlandia", flagIcon: "🇮🇪"),
  Language(id: "pt", name: "Portugis", flagIcon: "🇵🇹"),
];

class OnboardLanguageScreen extends StatefulWidget {
  const OnboardLanguageScreen({super.key});

  @override
  State<OnboardLanguageScreen> createState() => _OnboardLanguageScreenState();
}

class _OnboardLanguageScreenState extends State<OnboardLanguageScreen> {
  late final ScrollController _scrollController;
  String? _selectedLanguage;
  bool _isSliverAppBarPinned = false;

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
                  ? Text("Language", style: context.textTheme.titleSmall)
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
                    'Choose your language',
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: SpacingScale.xs),
                  Text(
                    'You can change this anytime in settings.',
                    style: context.textTheme.bodySmall,
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

              itemCount: languageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = languageList[index].id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SpacingScale.lg * 2),
                      border: Border.all(
                        color: _selectedLanguage == languageList[index].id
                            ? context.colorScheme.outline
                            : Colors.transparent,
                      ),
                      gradient: _selectedLanguage == languageList[index].id
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
                          languageList[index].flagIcon,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: IconSizeScale.lg * 2,
                          ),
                        ),
                        const SizedBox(height: SpacingScale.xs),
                        Text(
                          languageList[index].name,
                          textAlign: .center,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: _selectedLanguage == languageList[index].id
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
          text: 'Continue',
          isDisabled: _selectedLanguage == null,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnboardCurrencyScreen()),
            );
          },
        ),
      ),
    );
  }
}

import 'package:safuku/ui/core/themes/app_colors.dart';
import 'package:safuku/ui/core/themes/extensions/color_extension.dart';
import 'package:safuku/ui/core/themes/extensions/text_style_extension.dart';
import 'package:flutter/material.dart';

final ligtTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  extensions: <ThemeExtension<dynamic>>[
    textStyleCustomLight,
    colorExtensionLight,
  ],
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: AppColors.primary,
    surface: AppColors.surfaceLight,
    primary: AppColors.primary,
    onPrimary: AppColors.textPrimaryDark,
    error: AppColors.errorBackground,
    onError: AppColors.error,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textPrimaryLight,
    outline: AppColors.outlinedBorderLight,
  ),
  textTheme: const TextTheme(
    // Headline for current balance
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    // Title body
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),
    // Subtitle body
    bodySmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: AppColors.textLabelLight,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),

    // Title page
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),

    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),

    // Button
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textLabelLight,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textLabelLight,
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  extensions: <ThemeExtension<dynamic>>[
    textStyleCustomDark,
    colorExtensionDark,
  ],
  colorScheme: .fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.surfaceDark,
    primary: AppColors.primary,
    onPrimary: AppColors.textPrimaryDark,
    error: AppColors.errorBackground,
    onError: AppColors.error,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textPrimaryDark,
    outline: AppColors.outlinedBorderDark,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textLabelDark,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
    // Title page
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),

    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textLabelDark,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textLabelDark,
    ),
  ),
);

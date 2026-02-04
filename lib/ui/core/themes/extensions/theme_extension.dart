import 'package:safuku/ui/core/themes/extensions/color_extension.dart';
import 'package:safuku/ui/core/themes/extensions/text_style_extension.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  ColorExtension get colorExtension => theme.extension<ColorExtension>()!;
  TextStyleCustom get textStyleExtension => theme.extension<TextStyleCustom>()!;
  TextTheme get textTheme => theme.textTheme;

  // Media Query
  Size get screenSize => MediaQuery.of(this).size;
  double get width => screenSize.width;
  double get height => screenSize.height;
}

// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color linen = const Color(0xFFECE7E2);
Color spruce = const Color(0xFF4A7766);
Color forest = const Color(0xFF285B23);
Color parchment = const Color(0xFFFBF5DF);

Color deepForest = const Color(0xFF1E3F20);
Color mossGreen = const Color(0xFF4A7023);
Color sunlitLeaf = const Color(0xFF9BC53D);
Color earthyBrown = const Color(0xFF5C4033);
Color skyBlue = const Color(0xFF68C4AF);
const Color kLinen = Color(0xFFECE7E2);
const Color kSpruce = Color(0xFF4A7766);
const Color kForest = Color(0xFF285B23);
const Color kParchment = Color(0xFFFBF5DF);

// New attractive blue colors
const Color kVibrantBlue = Color(0xFF1E88E5);
const Color kDeepBlue = Color(0xFF0D47A1);

class AppTheme {
  // Base colors
  static const Color _primaryColor = Color(0xFF007AFF); // iOS blue
  static const Color _secondaryColor = Color(0xFF5AC8FA); // iOS light blue

  // Text colors
  static const Color _primaryTextColor = Color(0xFF000000);
  static const Color _secondaryTextColor = Color(0xFF8E8E93);

  // Background colors
  static const Color _backgroundColor = Color(0xFFF2F2F7);
  static const Color _secondaryBackgroundColor = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color _successColor = Color(0xFF34C759); // iOS green
  static const Color _warningColor = Color(0xFFFF9500); // iOS orange
  static const Color _errorColor = Color(0xFFFF3B30); // iOS red

  // Dark mode colors
  static const Color _darkPrimaryColor = Color(0xFF0A84FF);
  static const Color _darkBackgroundColor = Color(0xFF1C1C1E);
  static const Color _darkSecondaryBackgroundColor = Color(0xFF2C2C2E);
  static const Color _darkPrimaryTextColor = Color(0xFFFFFFFF);
  static const Color _darkSecondaryTextColor = Color(0xFF8E8E93);

  static Color _getColor(
      BuildContext context, Color lightColor, Color darkColor) {
    return MediaQuery.of(context).platformBrightness == Brightness.light
        ? lightColor
        : darkColor;
  }

  // AppBar
  static Color getAppBarBackgroundColor(BuildContext context) => _getColor(
      context, _secondaryBackgroundColor, _darkSecondaryBackgroundColor);
  static Color getAppBarForegroundColor(BuildContext context) =>
      _getColor(context, _primaryColor, _darkPrimaryColor);

  // Navigation Bar
  static Color getNavBarBackgroundColor(BuildContext context) => _getColor(
      context, _secondaryBackgroundColor, _darkSecondaryBackgroundColor);
  static Color getNavBarForegroundColor(BuildContext context) =>
      _getColor(context, _primaryColor, _darkPrimaryColor);

  // Scaffold
  static Color getScaffoldBackgroundColor(BuildContext context) =>
      _getColor(context, _backgroundColor, _darkBackgroundColor);

  // Text Colors
  static Color getPrimaryTextColor(BuildContext context) =>
      _getColor(context, _primaryTextColor, _darkPrimaryTextColor);
  static Color getSecondaryTextColor(BuildContext context) =>
      _getColor(context, _secondaryTextColor, _darkSecondaryTextColor);

  // Button Colors
  static Color getPrimaryButtonColor(BuildContext context) =>
      _getColor(context, _primaryColor, _darkPrimaryColor);
  static Color getSecondaryButtonColor(BuildContext context) =>
      _getColor(context, _secondaryColor, _secondaryColor);

  // Card Colors
  static Color getCardBackgroundColor(BuildContext context) => _getColor(
      context, _secondaryBackgroundColor, _darkSecondaryBackgroundColor);

  // Semantic Colors
  static Color getSuccessColor(BuildContext context) => _successColor;
  static Color getWarningColor(BuildContext context) => _warningColor;
  static Color getErrorColor(BuildContext context) => _errorColor;

  // Text Styles
  static TextStyle getHeadlineStyle(BuildContext context) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: getPrimaryTextColor(context),
      );

  static TextStyle getTitleStyle(BuildContext context) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: getPrimaryTextColor(context),
      );

  static TextStyle getBodyStyle(BuildContext context) => TextStyle(
        fontSize: 17,
        color: getPrimaryTextColor(context),
      );

  static TextStyle getCaptionStyle(BuildContext context) => TextStyle(
        fontSize: 13,
        color: getSecondaryTextColor(context),
      );
  static const Color _primaryIconColor = Color(0xFF007AFF); // iOS blue
  static const Color _secondaryIconColor = Color(0xFF8E8E93); // iOS gray
  static const Color _tertiaryIconColor = Color(0xFFC7C7CC); // iOS light gray

  static const Color _darkPrimaryIconColor =
      Color(0xFF0A84FF); // iOS dark mode blue
  static const Color _darkSecondaryIconColor =
      Color(0xFF8E8E93); // iOS dark mode gray
  static const Color _darkTertiaryIconColor =
      Color(0xFF48484A); // iOS dark mode light gray

  // Icon Colors
  static Color getPrimaryIconColor(BuildContext context) =>
      _getColor(context, _primaryIconColor, _darkPrimaryIconColor);

  static Color getSecondaryIconColor(BuildContext context) =>
      _getColor(context, _secondaryIconColor, _darkSecondaryIconColor);

  static Color getTertiaryIconColor(BuildContext context) =>
      _getColor(context, _tertiaryIconColor, _darkTertiaryIconColor);

  // Specific icon use cases
  static Color getTabBarIconColor(BuildContext context,
          {required bool isSelected}) =>
      isSelected
          ? getPrimaryIconColor(context)
          : getSecondaryIconColor(context);

  static Color getNavigationBarIconColor(BuildContext context) =>
      getPrimaryIconColor(context);

  static Color getActionIconColor(BuildContext context) =>
      getPrimaryIconColor(context);

  static Color getInactiveIconColor(BuildContext context) =>
      getTertiaryIconColor(context);

  // CupertinoThemeData
  static CupertinoThemeData getCupertinoThemeData(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: isDarkMode ? _darkPrimaryColor : _primaryColor,
      barBackgroundColor: isDarkMode
          ? _darkSecondaryBackgroundColor
          : _secondaryBackgroundColor,
      scaffoldBackgroundColor:
          isDarkMode ? _darkBackgroundColor : _backgroundColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: isDarkMode ? _darkPrimaryTextColor : _primaryTextColor,
        textStyle: getBodyStyle(context),
      ),
    );
  }
}

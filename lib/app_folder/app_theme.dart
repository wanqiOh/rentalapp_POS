import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFFFC9200);
  static const Color navBarColor = white;
  static const Color navBarTitleColor = grey;

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color dark_grey = Color(0xFF404040);
  static const Color grey = Color(0xFF707070);
  static const Color light_grey = Color(0xFFF0F0F0);
  static const Color red = Colors.red; // todo apply to all red text
  static const Color light_green = Color(0xFF41B957);
  static const Color marine_blue = Color(0xFF002F70);
  static const Color light_blue = Color(0xFFE6E9EF);
  static const Color bluish_grey = Color(0xFFE5E9F0);

  static const Color disabled_grey = Color(0xFFB6B6B6);
  static const Color primaryTextColor = dark_grey;
  static const Color secondaryTextColor = grey;
  static const Color captionTextColor = light_green;
  static const Color dialogTitleColor = black;
  static const Color dialogBtnColor = primaryColor;
  static const Color dialogBtnDisableColor = light_grey;
  static const Color dialogBtnTextColor = white;
  static const Color iconTextColor = marine_blue;
  static const Color cardContrastBackgroundColor = light_blue;
  static const String fontName = 'HelveticaNeue';

  static const TextTheme textTheme = TextTheme(
    headline1: title,
    headline2: dialogTitle,
    bodyText1: bodyText,
    caption: caption,
  );

  static const TextStyle navBarStyle = TextStyle(
    color: AppTheme.navBarTitleColor,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    color: captionTextColor,
    fontSize: smallTextSize, // was lightText
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
    fontSize: titleTextSize,
  );

  static const TextStyle dialogTitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    color: dialogTitleColor,
    fontSize: 21,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: fontName,
    color: secondaryTextColor,
  );

  static const TextStyle warningText = TextStyle(
    fontFamily: fontName,
    color: Colors.red,
    fontSize: extraSmallTextSize,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle themeColorText = TextStyle(
    fontFamily: fontName,
    color: primaryColor,
  );

  static const TextStyle smallText = TextStyle(
      fontFamily: fontName, color: primaryTextColor, fontSize: titleTextSize);

  static const TextStyle boldSmallText = TextStyle(
      fontFamily: fontName,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
      fontSize: titleTextSize);

  static const TextStyle cardText = TextStyle(
      fontFamily: fontName,
      color: AppTheme.secondaryTextColor,
      fontSize: smallTextSize);

  static BoxDecoration innerCardBorder = BoxDecoration(
      color: AppTheme.white,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(color: light_grey, width: 1.5),
      shape: BoxShape.rectangle);

  static const double largeMargin = 48.0;
  static const double mainMargin = 16.0;
  static const double subMargin = 8.0;

  static const double mediumHorizontalMargin = 24;
  static const double smallHorizontalMargin = 10;

  static const double titleTextSize = 15.0;
  static const double normalTextSize = 14.0;
  static const double smallTextSize = 12.0;
  static const double extraSmallTextSize = 10.0;
}

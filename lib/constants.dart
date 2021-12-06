import 'package:flutter/material.dart';

// material color
Map<int, Color> color = {
  50: kBrightBlue.withOpacity(.1),
  100: kBrightBlue.withOpacity(.2),
  200: kBrightBlue.withOpacity(.3),
  300: kBrightBlue.withOpacity(.4),
  400: kBrightBlue.withOpacity(.5),
  500: kBrightBlue.withOpacity(.6),
  600: kBrightBlue.withOpacity(.7),
  700: kBrightBlue.withOpacity(.8),
  800: kBrightBlue.withOpacity(.9),
  900: kBrightBlue.withOpacity(1),
};

MaterialColor materialColor = MaterialColor(0xFF3a7bfd, color);

// Primary
const Color kBrightBlue = Color(0xFF3a7bfd);
const Color kLinearBlue = Color(0xFF57ddff);
const Color kLinearPurple = Color(0xFFc058f3);

// Neutrals
const Color kLightThemeLightGrey = Color(0xFFfafafa);
const Color kLightThemeVeryLightGrayishBlue = Color(0xFFe4e5f1);
const Color kLightThemeLightGrayishBlue = Color(0xFFd2d3db);
const Color kLightThemeDarkGrayishBlue = Color(0xFF9394a5);
const Color kLightThemeVeryDarkGrayishBlue = Color(0xFF484b6a);

// Spacing
const double kDefaultSpacing = 8.0;

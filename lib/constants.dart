import 'package:flutter/material.dart';

// font size: 18px
// font family: Josefin Sans (https://fonts.google.com/specimen/Josefin+Sans)
// font weights: 400, 700

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

// Neutral
// Light Theme
const Color kLightThemeLightGrey = Color(0xFFfafafa);
const Color kLightThemeVeryLightGrayishBlue = Color(0xFFe4e5f1);
const Color kLightThemeLightGrayishBlue = Color(0xFFd2d3db);
const Color kLightThemeDarkGrayishBlue = Color(0xFF9394a5);
const Color kLightThemeVeryDarkGrayishBlue = Color(0xFF484b6a);

// Dark Theme
const Color kDarkThemeVeryDarkBlue = Color(0xFFfafafa);
const Color kDarkThemeVeryDarkDesaturatedBlue = Color(0xFF25273c);
const Color kDarkThemeLightGrayishBlue = Color(0xFFcacde8);
const Color kDarkThemeLightGrayishBlueHover = Color(0xFFe4e5f1);
const Color kDarkThemeDarkGrayishBlue = Color(0xFF777a92);
const Color kDarkThemeVeryDarkGrayishBlue = Color(0xFF4d5066);
const Color kDarkThemeVeryDarkGrayishBlue2 = Color(0xFF393a4c);

const double kDefaultSpacing = 8.0;

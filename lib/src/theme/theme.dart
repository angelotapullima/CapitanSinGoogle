import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData.dark().copyWith(
  //textTheme: GoogleFonts.muliTextTheme(),
  scaffoldBackgroundColor: InstagramColors.scaffoldDark,
  accentColor: InstagramColors.cardLight,
  cardColor: InstagramColors.cardDark,
  //textSelectionColor: InstagramColors.pink,
  textSelectionTheme: TextSelectionThemeData(selectionColor: InstagramColors.grey),

  //canvasColor: InstagramColors.cardLight,
  dividerColor: InstagramColors.categoryDark,
  hintColor: InstagramColors.cardLight,
  brightness: Brightness.light,
);

final lightTheme = ThemeData.light().copyWith(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: InstagramColors.scaffoldLigth,
  accentColor: InstagramColors.grey,
  cardColor: InstagramColors.cardLight,
  //textSelectionColor: InstagramColors.pink,
  textSelectionTheme: TextSelectionThemeData(selectionColor: InstagramColors.grey),
  //canvasColor: InstagramColors.pink,
  dividerColor: InstagramColors.categoryLight,
  hintColor: InstagramColors.colorHistoryLight,
  brightness: Brightness.dark,
);

class InstagramColors {
  static final Color fondoAppBar = Color(0xFFf7f7f7);
  static final Color purple = Color(0xFF8134AF);
  static final Color blue = Color(0xFFDD2A7B);
  static final Color yellow = Color(0xFFFDEA77);
  static final Color orange = Color(0xFFF58529);
  static final Color grey = Color(0xFFBABABA);
  static final Color scaffoldDark = Color(0xFF181818);
  static final Color scaffoldLigth = Color(0xFFF0F1F5);
  static final Color cardDark = Color(0xFF31323B);
  static final Color cardLight = Color(0xFFFFFFFF);
  static final Color categoryLight = Color(0xFFB5B5B5);
  static final Color categoryDark = Color(0xFF434343);
  static final Color colorHistoryLight = Color(0xFF909090);
}

class NewColors {
  static final Color black = Color(0xFF5A5A5A);
  static final Color orangeLight = Color(0xFFFF9700);
  static final Color grayBackSpace = Color(0xFFC4C4C4);
  static final Color green = Color(0xFF4CB050);
  static final Color grayBIcon = Color(0xFF808080);
  static final Color white = Color(0xFFF7F7F7);
  static final Color gayText = Color(0xFF8D9597);
  static final Color blackLogout = Color(0xFF353535);
  static final Color backGroundCarnet = Color(0xFF343434);
  static final Color grayCarnet = Color(0xFF808080);
  static final Color blue = Color(0xFF2186D0);
  static final Color purple = Color(0xFF9E00FF);
  static final Color plin = Color(0xFF00C7FE);
  static final Color card = Color(0xFF003663);
  static final Color barrasOff = Color(0XFFADADAD);
}

//bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

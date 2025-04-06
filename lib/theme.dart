import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF833AB4),
    brightness: Brightness.dark,
  ),
  fontFamily: GoogleFonts.roboto().fontFamily,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    foregroundColor: Color(0xFF833AB4),
    //backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      color: Color(0xFF833AB4),
      fontSize: 24,
    ),
  ),
);

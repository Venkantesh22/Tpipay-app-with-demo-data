import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Color primaryColor = const Color(0xFF941f37);
// Color secondaryColor = const Color(0xFF941f37).withOpacity(.47);
const Color primaryColor = Color(0xFF77309F);
Color secondaryColor = const Color(0xFF2C2067);
const Color thiryaryColor = Colors.blue;
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);
Color contactUsBackground = const Color(0xFFE2FEE9);
 Color primaryBgColor = Color(0XFF6541A7).withValues(alpha: 0.20);


const Color black = Colors.black;
const Color white = Colors.white;
const Color white2 = Color(0xFFF5F7FA);
const Color whiteAntiFlash = Color(0xFFF1F5F9);
const Color whiteAppbar = Color(0xFFF8F6F6);
const Color whiteAppbar2 = Color(0xFFF8F6F6CC);
Color greyLight = const Color(0xFFC4C4C4);
Color greyBackGround = const Color(0xFFEFEDED);
Color grey = const Color(0xFF999999);
Color greyText = const Color(0xFF5C5B5B);
Color greyText2 = const Color(0xFF6B7280);
Color greyText3 = const Color(0xFF355355);
Color greyText4 = const Color(0xFF9CA3AF);
Color greyText5 = const Color(0xFFC8C8C8);
Color greyText6 = const Color(0xFF475569);
Color greyDark = const Color(0xFFA1A1A1);
Color greyBorder = const Color(0xFFB9B9B9);
Color red = Colors.red;
Color redLight = Colors.red.withValues(alpha: 0.20);
Color purple = const Color(0xFF9333EA);
Color purpleLight = const Color(0xFF64748B);
Color blue = const Color(0xFF2563EB);
Color blueDark = const Color(0xFF0F172A);
Color origin = const Color(0xFFEA580C);
Color cyanDark = const Color(0xFF355355);
Color primaryColorLight =  Color(0XFF6541A7).withValues(alpha: 0.20);
Color yellow = Colors.yellow;

List<Color> loginBgColor = [
  const Color(0xFF355355),
  const Color(0xFF75B7BB),
];

const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xff838383);
Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static ThemeData light = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.grey[600],
    cardColor: Colors.grey[100],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[600],
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundLight,
      onBackground: Colors.black,
      surface: backgroundLight,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.publicSans(),
      displayMedium: GoogleFonts.robotoMono(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.notoSansLimbu(color: black),
      titleSmall: GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: 26,
      ),
      bodyLarge: GoogleFonts.inter(),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.black45,
    cardColor: Colors.grey[800],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[200],
    primaryColorDark: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundDark,
      onBackground: Colors.white,
      surface: backgroundDark,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: backgroundLight,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.openSans(),
      displayMedium: GoogleFonts.openSans(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.openSans(),
      titleSmall: GoogleFonts.openSans(),
      bodyLarge: GoogleFonts.openSans(),
      bodyMedium: GoogleFonts.openSans(),
      bodySmall: GoogleFonts.openSans(),
    ),
  );
}

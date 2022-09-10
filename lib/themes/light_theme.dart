import 'package:flutter/material.dart';

const brightness = Brightness.light;
const primaryColor = const Color(0xFF84E8B2);
const primaryColorDark = const Color(0xFF66B489);
const accentColor = const Color(0xFF808080);
const backgroundColor = const Color(0xFFF5F5F5);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}


ThemeData lightTheme() {

  Map<int, Color> colorCodes = {
  50: Color.fromRGBO(15, 192, 200, .0),
  100: Color.fromRGBO(15, 192, 200, .1),
  200: Color.fromRGBO(15, 192, 200, .2),
  300: Color.fromRGBO(15, 192, 200, .4),
  400: Color.fromRGBO(15, 192, 200, .5),
  500: Color.fromRGBO(15, 192, 200, .6),
  600: Color.fromRGBO(15, 192, 200, .7),
  700: Color.fromRGBO(15, 192, 200, .8),
  800: Color.fromRGBO(15, 192, 200, .9),
  900: Color.fromRGBO(15, 192, 200, 3),
};
// Green color code: FF93cd48
MaterialColor secondColor = MaterialColor(0x0FC0C848, colorCodes);


  return ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    backgroundColor: Colors.white,
    brightness: brightness,
    bottomAppBarTheme: BottomAppBarTheme (
      color: Colors.white,
      elevation: 5,
    ),
    fontFamily: "Vazir",
    primarySwatch:  secondColor,
    primaryColor:  Color.fromRGBO(2, 75, 156, 1),
    hintColor: Colors.grey[600],
    errorColor:Colors.red[600],
    primaryColorDark:  Color.fromRGBO(2, 75, 156, 5),
    buttonColor: secondColor,
  );
}

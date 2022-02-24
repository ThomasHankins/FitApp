import 'package:flutter/material.dart';

class AppThemes {
  AppThemes();
  ThemeData dark() {
    return ThemeData(
      fontFamily: 'Uniform',

      primaryColor: Colors.grey[900],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      backgroundColor: Colors.grey[800],
      canvasColor: Colors.grey[900],

      appBarTheme: AppBarTheme(
        color: Colors.grey[850],
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.grey[850],
      ),

      listTileTheme: ListTileThemeData(
        tileColor: Colors.grey[850],
        selectedTileColor: Colors.grey[800],
        selectedColor: Colors.white,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(),

      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.accent,
      ),

      //this removes the splash effect
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Uniform',
      iconTheme: const IconThemeData(),
      buttonTheme: const ButtonThemeData(
        shape: RoundedRectangleBorder(),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
        headline6: TextStyle(
            fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black),
        bodyText2:
            TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
      ),
    );
  }
}

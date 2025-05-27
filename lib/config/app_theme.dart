// Suggested code may be subject to a license. Learn more: ~LicenseLog:3511695679.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:667659259.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3763360813.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1355483438.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2415778430.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:30914493.
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey[800],
      hintColor: Colors.tealAccent[400],
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: Colors.tealAccent[400],
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey[900],
      hintColor: Colors.tealAccent[700],
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: Colors.tealAccent[700],
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white70),
        titleMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white60),
        bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white54),
      ),
    );
  }
}

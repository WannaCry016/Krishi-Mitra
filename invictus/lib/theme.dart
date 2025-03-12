// import 'package:flutter/material.dart';

// final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: Colors.white,
//     useMaterial3: true,
//     colorScheme: ColorScheme(
//         brightness: Brightness.light,
//         primary: Colors.white,
//         onPrimary: Colors.redAccent,
//         secondary: Colors.deepPurple,
//         onSecondary: Colors.pink,
//         error: Colors.red,
//         onError: Colors.green,
//         surface: Colors.white,
//         onSurface: Colors.black,
//         shadow: Colors.black));

// final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: Colors.deepPurple,
//     colorScheme: ColorScheme(
//         brightness: Brightness.dark,
//         primary: Colors.white,
//         onPrimary: Colors.redAccent,
//         secondary: Colors.deepPurple,
//         onSecondary: Colors.pink,
//         error: Colors.red,
//         onError: Colors.green,
//         surface: Colors.black,
//         onSurface: Colors.purple,
//         shadow: Colors.white),
//     useMaterial3: true);




import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
    // brightness: Brightness.light,
    // primaryColor: Colors.white,
    // useMaterial3: true,
    fontFamily: "Poppins-Regular",
    // colorScheme: ColorScheme(
    //     brightness: Brightness.light,
    //     primary: Colors.white,
    //     onPrimary: Colors.redAccent,
    //     secondary: Colors.deepPurple,
    //     onSecondary: Colors.pink,
    //     error: Colors.red,
    //     onError: Colors.green,
    //     surface: Colors.white,
    //     onSurface: Colors.black,
    //     shadow: Colors.black),
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: Colors.black), // Default text color for light mode
    //   bodyMedium: TextStyle(color: Colors.black),
    // ),
    // scaffoldBackgroundColor: Colors.white // Background for light mode
);

// final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: Colors.deepPurple,
//     useMaterial3: true,
//     colorScheme: ColorScheme(
//         brightness: Brightness.dark,
//         primary: Colors.deepPurple,
//         onPrimary: Colors.white, // Text color in primary sections
//         secondary: Colors.deepPurple,
//         onSecondary: Colors.white,
//         error: Colors.red,
//         onError: Colors.green,
//         surface: Colors.black,
//         onSurface: Colors.white, // Text color on surface
//         shadow: Colors.deepPurple),
//     scaffoldBackgroundColor: Colors.black, // Set background color to black
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white), // White text color for dark mode
//       bodyMedium: TextStyle(color: Colors.white),
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.black, // Black app bar
//       iconTheme: IconThemeData(color: Colors.deepPurple), // Icon color
//       titleTextStyle: TextStyle(color: Colors.white), // Title text color in the app bar
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//         backgroundColor: WidgetStateProperty.all(Colors.deepPurple), // Button background color
//         foregroundColor: WidgetStateProperty.all(Colors.white), // Button text color
//       ),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: Colors.black, // Bottom navigation background
//       selectedItemColor: Colors.deepPurple, // Selected item color
//       unselectedItemColor: Colors.white, // Unselected item text color
//     ));

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
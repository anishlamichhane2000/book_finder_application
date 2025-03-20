import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_finder_application/feature/home/home_bloc.dart';
import 'package:book_finder_application/feature/home/ui/home_screen.dart';
import 'package:book_finder_application/feature/favourite/ui/favourite_page.dart';
import 'splash_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  // Light Theme Data
  final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  // Dark Theme Data
  final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Finder App',
        theme: lightTheme, 
        darkTheme: darkTheme, 
        themeMode:
            isDarkMode ? ThemeMode.dark : ThemeMode.light, 
        home: const SplashScreen(), 
        routes: {
          '/home': (context) => HomeScreen(
                onThemeToggle: () {
                  setState(() {
                    isDarkMode = !isDarkMode; // Toggle dark/light mode
                  });
                },
              ),
          '/favourite': (context) => const FavouriteScreen(),
        },
      ),
    );
  }
}

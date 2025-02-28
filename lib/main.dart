import 'package:flutter/material.dart';
import 'screens/scheduler_home_screen.dart';

void main() {
  runApp(const EfficialsApp());
}

class EfficialsApp extends StatelessWidget {
  const EfficialsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Efficials',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          iconTheme: IconThemeData(size: 36),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          iconSize: 30,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.black, width: 2),
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // Updated font size and weight
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: const SchedulerHomeScreen(),
    );
  }
}

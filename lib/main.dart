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
          backgroundColor: Color(0xFF2196F3), // Blue from PDF
          iconTheme: IconThemeData(
            size: 36,
          ), // Larger icons in app bar (increased from 30 to 36)
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3), // Blue FAB
          foregroundColor: Colors.white, // White icon/text
          iconSize: 30, // FAB "+" icon size
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50), // Uniform button size
            textStyle: const TextStyle(
              fontSize: 16,
            ), // Uniform button text size
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18), // Default text size
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ), // For headings
        ),
      ),
      home: const SchedulerHomeScreen(),
    );
  }
}

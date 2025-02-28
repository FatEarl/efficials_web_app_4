import 'package:flutter/material.dart';
import 'scheduler_home_screen.dart';
import 'select_sport_screen.dart';
import 'create_schedule_screen.dart';
import 'select_officials_list_screen.dart';
import 'add_officials_screen.dart';
import 'add_officials_to_list_screen.dart';

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
          iconTheme: IconThemeData(size: 36, color: Colors.white),
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
            minimumSize: const Size(250, 50),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(color: Colors.black, width: 2),
          checkColor: const MaterialStatePropertyAll(Colors.white),
          fillColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.contains(MaterialState.selected)
                    ? const Color(0xFF2196F3)
                    : Colors.white,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF2196F3),
          selectionColor: Color(0xFF2196F3),
          selectionHandleColor: Color(0xFF2196F3),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: child!,
        );
      },
      initialRoute: '/home',
      routes: {
        '/home': (context) => const SchedulerHomeScreen(),
        '/select_sport': (context) => const SelectSportScreen(),
        '/create_schedule':
            (context) => CreateScheduleScreen(
              selectedSport:
                  ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/select_officials_list':
            (context) => SelectOfficialsListScreen(
              scheduleName:
                  ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/add_officials': (context) => const AddOfficialsScreen(),
        '/add_officials_to_list': (context) => const AddOfficialsToListScreen(),
      },
    );
  }
}

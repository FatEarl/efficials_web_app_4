import 'package:flutter/material.dart';
import 'scheduler_home_screen.dart';
import 'select_sport_screen.dart';
import 'create_schedule_screen.dart';
import 'select_officials_list_screen.dart';
import 'add_officials_screen.dart';
import 'add_officials_to_list_screen.dart';
import 'location_screen.dart';
import 'add_new_location_screen.dart';
import 'date_time_screen.dart';
import 'additional_game_info_screen.dart';
import 'lists_of_officials_screen.dart';
import 'create_new_list_screen.dart';
import 'populate_roster_screen.dart';
import 'filter_settings_screen.dart';
import 'review_list_screen.dart';
import 'name_list_screen.dart';
import 'edit_list_screen.dart'; // Added this import

void main() => runApp(const EfficialsApp());

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class EfficialsApp extends StatelessWidget {
  const EfficialsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: MaterialApp(
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
            checkColor: const WidgetStatePropertyAll(Colors.white),
            fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
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
            labelStyle: TextStyle(color: Colors.black),
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
        builder: (context, child) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child!,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const SchedulerHomeScreen(),
          '/select_sport': (context) => const SelectSportScreen(),
          '/create_schedule': (context) => const CreateScheduleScreen(),
          '/select_officials_list': (context) =>
              const SelectOfficialsListScreen(),
          '/add_officials': (context) => const AddOfficialsScreen(),
          '/add_officials_to_list': (context) =>
              const AddOfficialsToListScreen(),
          '/location': (context) => const LocationScreen(),
          '/add_new_location': (context) => const AddNewLocationScreen(),
          '/date_time': (context) => const DateTimeScreen(),
          '/additional_game_info': (context) =>
              const AdditionalGameInfoScreen(),
          '/lists_of_officials': (context) => const ListsOfOfficialsScreen(),
          '/create_new_list': (context) => const CreateNewListScreen(),
          '/name_list': (context) => const NameListScreen(),
          '/populate_roster': (context) => const PopulateRosterScreen(),
          '/filter_settings': (context) => const FilterSettingsScreen(),
          '/review_list': (context) => const ReviewListScreen(),
          '/edit_list': (context) => const EditListScreen(), // Already added
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'game_info.dart';

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key});

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder:
          (context, child) => Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF2196F3),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF2196F3),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              timePickerTheme: const TimePickerThemeData(
                dialHandColor: Color(0xFF2196F3),
                hourMinuteTextColor: Colors.black,
                entryModeIconColor: Color(0xFF2196F3),
                hourMinuteColor: Colors.white,
                dayPeriodTextColor: Colors.black,
                dayPeriodColor: Color(0xFF2196F3),
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleName = ModalRoute.of(context)!.settings.arguments as String;
    const sport = 'Football';
    const location = 'Triad - Underclass Field';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Date/Time',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.monetization_on,
                  size: 36,
                  color: Colors.white,
                ),
                onPressed:
                    () => ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Tokens: 1'))),
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'When will the game be played?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (selectedDate != null || selectedTime != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '${selectedDate != null ? 'Date: ${DateFormat('MMMM dd, yyyy').format(selectedDate!)}\n' : ''}${selectedTime != null ? 'Time: ${selectedTime!.format(context)}' : ''}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize: const Size(200, 60),
                      ),
                      child: Text(
                        selectedDate == null ? 'Set Date' : 'Change Date',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize: const Size(200, 60),
                      ),
                      child: Text(
                        selectedTime == null ? 'Set Time' : 'Change Time',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedDate != null && selectedTime != null) {
                          final officials = [
                            'Official 1',
                            'Official 2',
                            'Official 3',
                            'Official 4',
                          ];
                          final gameInfo = GameInfo(
                            sport: sport,
                            scheduleName: scheduleName,
                            date: selectedDate!,
                            time: selectedTime!,
                            location: location,
                            officials: officials,
                          );
                          Navigator.pushNamed(
                            context,
                            '/additional_game_info',
                            arguments: gameInfo,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select both date and time!',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize: const Size(250, 70),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

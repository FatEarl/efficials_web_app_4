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
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const SchedulerHomeScreen(),
    );
  }
}

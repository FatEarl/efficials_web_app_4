import 'package:flutter/material.dart';

class GameInfo {
  final String sport;
  final String scheduleName;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final List<String> officials;
  final String level;
  final String gender;
  final int officialsRequired;
  final int feePerOfficial;
  final bool isFirstComeFirstServed;

  GameInfo({
    required this.sport,
    required this.scheduleName,
    required this.date,
    required this.time,
    required this.location,
    required this.officials,
    this.level = '',
    this.gender = '',
    this.officialsRequired = 0,
    this.feePerOfficial = 0,
    this.isFirstComeFirstServed = false,
  });
}

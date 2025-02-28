import 'package:flutter/material.dart';

class GameInfo {
  final String sport;
  final String scheduleName;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final List<String> officials;

  GameInfo({
    required this.sport,
    required this.scheduleName,
    required this.date,
    required this.time,
    required this.location,
    required this.officials,
  });
}

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextAlign textAlign;
  final TextStyle style;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.textAlign,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      textAlign: textAlign,
      style: style,
      enableSuggestions: false,
      autocorrect: false,
      showCursor: true,
    );
  }
}

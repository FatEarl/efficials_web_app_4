import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextAlign textAlign;
  final TextStyle? style;
  const CustomTextField({
    super.key,
    this.controller,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.style,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      textAlign: textAlign,
      style: style,
      contextMenuBuilder:
          (context, editableTextState) => const SizedBox.shrink(),
      enableInteractiveSelection: false,
      enableSuggestions: false,
      autocorrect: false,
      showCursor: true,
    );
  }
}

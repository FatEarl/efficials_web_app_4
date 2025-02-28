import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextAlign textAlign;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? Function(
    BuildContext, {
    int currentLength,
    bool isFocused,
    int? maxLength,
  })?
  buildCounter;

  const CustomTextField({
    super.key,
    this.controller,
    this.decoration,
    this.textAlign = TextAlign.start,
    this.style,
    this.keyboardType,
    this.maxLength,
    this.buildCounter,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      textAlign: textAlign,
      style: style,
      keyboardType: keyboardType,
      maxLength: maxLength,
      buildCounter: buildCounter,
      contextMenuBuilder:
          (context, editableTextState) => const SizedBox.shrink(),
      enableInteractiveSelection: false,
      enableSuggestions: false,
      autocorrect: false,
      showCursor: true,
    );
  }
}

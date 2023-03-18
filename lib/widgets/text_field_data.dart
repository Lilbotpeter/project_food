import 'package:flutter/material.dart';

class TextFieldInputData extends StatelessWidget {
  final IconData icons;
  final TextInputType textInputType;

  const TextFieldInputData(
      {Key? key, required this.icons, required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      decoration: InputDecoration(
        icon: Icon(icons),
        border: InputBorder,
        focusedBorder: InputBorder,
        enabledBorder: InputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
    );
  }
}

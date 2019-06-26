import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key key,
    @required this.controller,
    @required this.hintText,
    @required this.inputType,
    this.autoFocus,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      keyboardType: inputType,
      validator: (value) {
        if (value.isEmpty) {
          return 'Field can not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade300,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          ),
        ),
      ),
    );
  }
}

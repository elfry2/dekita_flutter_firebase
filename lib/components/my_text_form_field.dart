import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool autofocus;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  const MyTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      onTap: onTap,
      onChanged: onChanged,
      obscureText: obscureText,
    );
  }
}

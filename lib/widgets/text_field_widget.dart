import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.keyboardType,
    this.contr,
  });
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? contr;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: contr,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
      ),
    );
  }
}

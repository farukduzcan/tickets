import 'package:flutter/material.dart';
import 'package:tickets/components/text_field_container.dart';
import '../constants.dart';

class InputField extends StatelessWidget {
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Iterable<String> autofillHints;
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const InputField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    required this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validateMessage;
          }
          return null;
        },
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: hintText,
            icon: Icon(icon),
            iconColor: kPrimaryColor,
            border: InputBorder.none),
      ),
    );
  }
}

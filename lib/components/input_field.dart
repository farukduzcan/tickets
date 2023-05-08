import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tickets/components/text_field_container.dart';
import '../constants.dart';

class InputField extends StatelessWidget {
  final Color color;
  final FocusNode? focusnode;
  final TextEditingController? controller;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Iterable<String> autofillHints;
  final String hintText;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  const InputField({
    super.key,
    required this.hintText,
    this.icon,
    required this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    required this.autofillHints,
    this.inputFormatters = const [],
    this.controller,
    this.focusnode,
    this.color = kPrimaryLightColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color,
      boxshodow: kFieldBoxShodow,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validateMessage;
          }
          return null;
        },
        focusNode: focusnode,
        controller: controller,
        inputFormatters: inputFormatters,
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

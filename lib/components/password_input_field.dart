import 'package:flutter/material.dart';
import 'package:tickets/components/text_field_container.dart';
import '../constants.dart';

class RaundedPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusnode;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final String hintText;
  const RaundedPasswordField({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.focusnode,
  });

  @override
  State<RaundedPasswordField> createState() => _RaundedPasswordFieldState();
}

class _RaundedPasswordFieldState extends State<RaundedPasswordField> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        textInputAction: widget.textInputAction,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validateMessage;
          }
          return null;
        },
        focusNode: widget.focusnode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: _isHidden,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(Icons.lock),
          iconColor: kPrimaryColor,
          border: InputBorder.none,
          suffixIcon: IconButton(
            splashRadius: 1.0,
            onPressed: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            icon: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

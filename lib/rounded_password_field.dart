import 'package:flutter/material.dart';
import 'package:i_call/text_field_container.dart';


import 'constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
     this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Color(0xff005AA6),
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Color(0xff005AA6),
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Color(0xff005AA6),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

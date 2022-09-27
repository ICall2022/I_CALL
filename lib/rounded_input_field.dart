import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_call/text_field_container.dart';


import 'constants.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
   RoundedInputField({
    Key key,
     this.hintText,
    this.icon = Icons.phone,
     this.onChanged,
  }) : super(key: key);
  TextEditingController _otpcontroller=new TextEditingController();
  TextEditingController _namecontroller=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(


        cursorColor: Color(0xff005AA6),
        decoration: InputDecoration(

          icon: Icon(
            icon,
            color: Color(0xff005AA6),
          ),
          hintText: "Enter Phone Number",
          border: InputBorder.none,


        ),
        keyboardType: TextInputType.phone,

        controller: _otpcontroller,

      ),
    );

  }
}

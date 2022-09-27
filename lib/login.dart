
import 'package:flutter/material.dart';

import 'bodylogin.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key key}) : super(key: key);

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Bodylogin(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/text_field_container.dart';
import 'package:lottie/lottie.dart';

import 'background.dart';
import 'lodinotp.dart';
import 'rounded_button.dart';



class Bodylogin extends StatefulWidget {
  const Bodylogin({Key key}) : super(key: key);

  @override
  State<Bodylogin> createState() => _BodyloginState();
}

class _BodyloginState extends State<Bodylogin> {
  TextEditingController _otpcontroller=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(


      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(

                width: size.width/0.5,
                height: size.height /2.9,


                  child: Lottie.asset("assets/Reg.json"),

                ),

            Text(
                "Register with us,",
                style: GoogleFonts.raleway(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFE67C4)
                )


            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Text(

                  "Kindly enter your phone number",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black
                  )


              ),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 60,bottom: 2),
              child: TextFieldContainer(
                child: TextField(


                  cursorColor: Color(0xffF84F9D),
                  decoration: InputDecoration(

                    icon: Icon(
                      Icons.phone,
                      color: Color(0xffF84F9D),
                    ),
                    hintText: " +91 - Phone Number",
                    border: InputBorder.none,


                  ),
                  keyboardType: TextInputType.phone,

                  controller: _otpcontroller,

                ),
              ),
            ),

            /*RoundedPasswordField(
              onChanged: (value) {},
            ),*/
        Padding(
          padding: const EdgeInsets.only(top: 20,bottom: 2),
          child: Container(
            width: 265,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xffFE67C4),
                      Color(0xffFA79C9)
                    ]
                )
            ),
            child: TextButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Loginotp(_otpcontroller.text)));

              },
              child: Text("Register", style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
            ),
          ),
        ),
            SizedBox(height: size.height * 0.03),

          ],
        ),
      ),
    );
  }
}



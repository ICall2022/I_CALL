import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/Background2.dart';
import 'package:i_call/Welcome2.dart';
import 'package:i_call/login.dart';
import 'package:i_call/rounded_button.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background2(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[



            Container(

                width: size.width/0.5,
                height: size.height /2.9,
              child: Lottie.asset("assets/Welocome.json"),
               ),
            SizedBox(height: size.height * 0.1),
            Text(
              "Hi, \n Welcome to I CALL",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xffFE67C4)
              )


            ),
            Text(
              "The best app for your privacy",
              style: GoogleFonts.raleway(
                fontSize: 17,
                fontWeight: FontWeight.w300,
                color: Colors.black
              )


            ),



            /*RoundedPasswordField(
                onChanged: (value) {},
              ),*/

          Padding(
            padding: const EdgeInsets.only(top: 80,bottom: 2),
            child: Container(
              width: 205,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> WelcomeScreen2())
                  );
                },
                child: Text("Next", style: GoogleFonts.poppins(
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/Background2.dart';
import 'package:i_call/login.dart';
import 'package:i_call/rounded_button.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen2 extends StatefulWidget {
  const WelcomeScreen2({Key key}) : super(key: key);

  @override
  State<WelcomeScreen2> createState() => _WelcomeScreen2State();
}

class _WelcomeScreen2State extends State<WelcomeScreen2> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background3(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[



            Container(

              width: size.width/0.5,
              height: size.height /2.9,
              child: Lottie.asset("assets/welcome2.json"),
            ),
            SizedBox(height: size.height * 0.1),
            Text(
                "Enjoy your time,\n which is precious!",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFE67C4)
                )


            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0,vertical: 10),
              child: Text(
                  "Our  app's unique feature will automatically delete your within 2 days",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Colors.black
                  )


              ),
            ),



            /*RoundedPasswordField(
                onChanged: (value) {},
              ),*/

            Padding(
              padding: const EdgeInsets.only(top: 40,bottom: 2),
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> loginpage())
                    );
                  },
                  child: Text("Let's get Started", style: GoogleFonts.poppins(
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

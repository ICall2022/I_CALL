import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/Background2.dart';
import 'package:i_call/Welcome2.dart';
import 'package:i_call/login.dart';
import 'package:i_call/rounded_button.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    getContact();
    // TODO: implement initState
    super.initState();
  }

  void getContact() async {

    try {
      await Permission.contacts.request();
      final sw = Stopwatch()
        ..start();
      final contacts = await FastContacts.allContacts;
      sw.stop();
      _contacts = contacts;

      for (int i = 0; i < _contacts.length; i++) {

        FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').doc(i.toString()).set({
          'name': _contacts[i].displayName.toString(),

          'phone':  _contacts[i].phones.first.toString() != "" ? _contacts[i].phones.first.toString().replaceAll(new RegExp(r'[^0-9]'),'') : "null"



        });

      }
    }
    on PlatformException {

    }
  }
  firsttime()async{
    final snap = await FirebaseFirestore.instance.
    collection('users')
        .doc(_userik.uid.toString()) // varuId in your case
        .get();

    if (snap['first'] == 0) {


      FirebaseFirestore.instance.
      collection('users')
          .doc(_userik.uid.toString()).update({

        "first" : 1
      }
      );
    }
    if (snap['first'] == 1) {


      FirebaseFirestore.instance.
      collection('users')
          .doc(_userik.uid.toString()).update({

        "first" : 2
      }
      );



    }
    if (snap['first'] == 2) {
      setState(() {
        first = 2;
      });

    }

  }
  int first;

  User _userik = FirebaseAuth.instance.currentUser;
  List<Contact> _contacts = const [];

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
                    MaterialPageRoute(builder: (context)=> WelcomeScreen2(first))
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

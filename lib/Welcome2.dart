import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/Background2.dart';
import 'package:i_call/login.dart';
import 'package:i_call/rounded_button.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen2 extends StatefulWidget {
  int first;
  WelcomeScreen2(this.first);

  @override
  State<WelcomeScreen2> createState() => _WelcomeScreen2State();
}

class _WelcomeScreen2State extends State<WelcomeScreen2> {
  User _userik = FirebaseAuth.instance.currentUser;
  Mycontacts() async {
    int i;
    var document = await  FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').get();
    var docu = await  FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').get();
    var allusers = await  FirebaseFirestore.instance.collection("users").get();

    if(widget.first!=2){
      for (i = 0; i < document.docs.length; i++) {
        if (document.docs[i]['phone']
            .toString()
            .length >= 10) {
          for (int j = 0; j < allusers.docs.length; j++) {
            allusers.docs[j]['phone'].contains(
                document.docs[i]['phone'].toString().substring(2)) ?
            FirebaseFirestore.instance.collection("users").doc(
                _userik.uid.toString()).collection('Mycontacts').doc(
                allusers.docs[j]['userId']).set({
              'name': document.docs[i]['name'].toString(),
              'userId': allusers.docs[j]['userId'],
              'FCMToken': allusers.docs[j]['FCMToken'],
              'userImageUrl': allusers.docs[j]['userImageUrl'],
              'phone': allusers.docs[j]['phone'],
              'userId': allusers.docs[j]['userId'],


            }) : null;
          }
        }
        else {
          for (int j = 0; j < allusers.docs.length; j++) {
            allusers.docs[j]['phone'].contains(
                document.docs[i]['phone'].toString()) ?
            FirebaseFirestore.instance.collection("users").doc(
                _userik.uid.toString()).collection('Mycontacts').doc(
                allusers.docs[j]['userId']).set(
                {
                  'name': document.docs[i]['name'].toString(),
                  'userId': allusers.docs[j]['userId'],
                  'FCMToken': allusers.docs[j]['FCMToken'],
                  'userImageUrl': allusers.docs[j]['userImageUrl'],
                  'phone': allusers.docs[j]['phone'],
                  'userId': allusers.docs[j]['userId'],
                })

                : null;
          }
        }
      }

    }

    else {
      for (i = 0; i < document.docs.length; i++) {
        if (document.docs[i]['phone'].toString().length >= 10) {
          for (int j = 0; j < allusers.docs.length; j++) {

            final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('Mycontacts').doc(allusers.docs[j]['userId']).get();
            if(docSnapshot.exists) {
              allusers.docs[j]['phone'].contains(document.docs[i]['phone'].toString().substring(2)) ?
              FirebaseFirestore.instance.collection("users").doc(
                  _userik.uid.toString()).collection('Mycontacts').doc(
                  allusers.docs[j]['userId']).update({
                'name': document.docs[i]['name'].toString(),
                'userId': allusers.docs[j]['userId'],
                'FCMToken': allusers.docs[j]['FCMToken'],
                'userImageUrl': allusers.docs[j]['userImageUrl'],
                'phone': allusers.docs[j]['phone'],
                'userId': allusers.docs[j]['userId'],


              }) : null;
            }
            else {
              allusers.docs[j]['phone'].contains(document.docs[i]['phone'].toString().substring(2)) ?
              FirebaseFirestore.instance.collection("users").doc(
                  _userik.uid.toString()).collection('Mycontacts').doc(
                  allusers.docs[j]['userId']).set({
                'name': document.docs[i]['name'].toString(),
                'userId': allusers.docs[j]['userId'],
                'FCMToken': allusers.docs[j]['FCMToken'],
                'userImageUrl': allusers.docs[j]['userImageUrl'],
                'phone': allusers.docs[j]['phone'],
                'userId': allusers.docs[j]['userId'],


              }) : null;

            }

          }
        }
        else {
          for (int j = 0; j < allusers.docs.length; j++) {
            final docSnapshot = await FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('Mycontacts').doc(allusers.docs[j]['userId']).get();
            if(docSnapshot.exists) {
              allusers.docs[j]['phone'].contains(document.docs[i]['phone'].toString()) ?
              FirebaseFirestore.instance.collection("users").doc(
                  _userik.uid.toString()).collection('Mycontacts').doc(
                  allusers.docs[j]['userId']).update(
                  {
                    'name': document.docs[i]['name'].toString(),
                    'userId': allusers.docs[j]['userId'],
                    'FCMToken': allusers.docs[j]['FCMToken'],
                    'userImageUrl': allusers.docs[j]['userImageUrl'],
                    'phone': allusers.docs[j]['phone'],
                    'userId': allusers.docs[j]['userId'],
                  })

                  : null;
            }
            else {
              allusers.docs[j]['phone'].contains(document.docs[i]['phone'].toString()) ?
              FirebaseFirestore.instance.collection("users").doc(
                  _userik.uid.toString()).collection('Mycontacts').doc(
                  allusers.docs[j]['userId']).set(
                  {
                    'name': document.docs[i]['name'].toString(),
                    'userId': allusers.docs[j]['userId'],
                    'FCMToken': allusers.docs[j]['FCMToken'],
                    'userImageUrl': allusers.docs[j]['userImageUrl'],
                    'phone': allusers.docs[j]['phone'],
                    'userId': allusers.docs[j]['userId'],
                  })

                  : null;

            }

          }
        }
      }
    }

  }
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

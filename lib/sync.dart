import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/recentscreen.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class Sync extends StatefulWidget {
  const Sync({Key key}) : super(key: key);

  @override
  State<Sync> createState() => _SyncState();
}

class _SyncState extends State<Sync> {
@override
  void initState() {
  getContact();
  Timer(Duration(seconds: 10),

          ()=>Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>   recentscreen(nameuser,Imgurl,chatno,phone),
          )
      )
  );
  Stream collectionStream = FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('Mycontacts').snapshots();

  userdetail();

  newuser();
  // TODO: implement initState
    super.initState();
  }
  double perscent= 0;

  User _userik = FirebaseAuth.instance.currentUser;

  void getContact() async {
    try {
      await Permission.contacts.request();
      final sw = Stopwatch()
        ..start();
      final contacts = await FastContacts.allContacts;
      sw.stop();
      _contacts = contacts;

      for (int i = 0; i < _contacts.length; i++) {
        FirebaseFirestore.instance.collection("users").doc(
            _userik.uid.toString()).collection('contacts')
            .doc(i.toString())
            .set({
          'name': _contacts[i].displayName.toString(),

          'phone': _contacts[i].phones.first.toString() != "" ? _contacts[i]
              .phones.first.toString()
              .replaceAll(new RegExp(r'[^0-9]'), '') : "null"
        });
        setState(() {
          perscent = i/_contacts.length *100;
        });

      }



    }
    on PlatformException {

    }
  }
  List<Contact> _contacts = const [];
userdetail() async {
  var collection = FirebaseFirestore.instance.collection('users');
  var docSnapshot = await collection.doc(_userik.uid.toString()).get();
  Map<String, dynamic> data = docSnapshot.data();

  nameuser = data['name'];
  Imgurl = data['userImageUrl'];
  phone =data['phone'];

}
int i;
var nameuser;
var Imgurl;
String phone ="";
int chatno = 1;
newuser()  async {

  final result =  await FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('chatlist').get();
  if (result.size == 0) {
    setState(() {
      chatno = 2;

    });

  }
}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width/0.5,
            height: size.height /2.9,
            child: Lottie.asset("assets/file.json"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Your contacts is beening synced with \n I CALL , Kindly wait for moment \n Please don't press back button",style: TextStyle(
              fontSize: 16,fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.center,
            )),
          ),
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

                },
                child: Text("Sync is on process...", style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
              ),
            ),
          ),

        ],
      ),

    );
  }
}

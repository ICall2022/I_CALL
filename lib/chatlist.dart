import 'dart:async';
import 'dart:async';
import 'dart:typed_data';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/fb_messaging.dart';
import 'Controllers/image_controller.dart';
import 'Controllers/utils.dart';
import 'Home.dart';
import 'chatroom.dart';
import 'subWidgets/common_widgets.dart';
import 'subWidgets/local_notification_view.dart';

class ChatList extends StatefulWidget {


  @override _ChatList createState() => _ChatList();
}

class _ChatList extends State<ChatList> with LocalNotificationView {

  @override
  void initState() {
    getContact();


    super.initState();
    NotificationController.instance.updateTokenToServer();



    if (mounted) {
      checkLocalNotification(localNotificationAnimation, "");
    }
  }
  int ln;
  int i=0;
  List  user =[];
  User _userik = FirebaseAuth.instance.currentUser;

  void localNotificationAnimation(List<dynamic> data) {
    if (mounted) {
      setState(() {
        if (data[1] == 1.0) {
          localNotificationData = data[0];
        }
        localNotificationAnimationOpacity = data[1] as double;
      });
    }
  }
  String name = "";


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: i ==0 ? AppBar(
        toolbarHeight: 90,
        backgroundColor: Color(0xffF84F9D),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title:Row(
          children: [



            Text('Select a contact'),
            Padding(
              padding:  EdgeInsets.only(left:70.0),
              child: GestureDetector(
                onTap: (){
            setState(() {
              i=1;
            });

                },
                child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.search),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20)

                  ),

                ),
              ),
            ),

          ],
        ),


        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(37),
          ),
        ),
      ) : AppBar(
        toolbarHeight: 90,
        backgroundColor: Color(0xffF84F9D),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0)
            ),

            child: TextField(

              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, ), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
        flexibleSpace: Container(
          height: 260,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(37),
              ),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xffF84F9D),
                    Color(0xffE868A3)
                  ])
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(37),
          ),
        ),
      ),
body:  StreamBuilder(
  stream: FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('contacts').snapshots(),
  builder: (context ,AsyncSnapshot<QuerySnapshot> snapshots){
    if(!snapshots.hasData){
      return CircularProgressIndicator();
    }
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: snapshots.data.docs.map((firstcollection) {
            return  StreamBuilder(

              stream: FirebaseFirestore.instance
                  .collection('users')
              .where('phone',whereIn: [firstcollection['phone'],firstcollection['phone'].toString().substring(4)])

                  .snapshots(),


              builder: (context ,AsyncSnapshot<QuerySnapshot> chatid){
                return Stack(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: chatid.data.docs.map((secoundcollection) {
                        return Text(firstcollection['name']);
                      }).toList(),
                    )




                  ],
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  },
)

    );
  }

  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_userik.uid.toString()).get();
    Map<String, dynamic> data = docSnapshot.data();
    var name = data['name'];
    var Imgurl = data['userImageUrl'];
    try {
      String chatID = makeChatId(_userik.uid.toString(), selectedUserID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatRoom(
                      _userik.uid.toString(),
                      name.toString(),
                      Imgurl.toString(),
                      selectedUserToken,
                      selectedUserID,
                      chatID,
                      selectedUserName,
                      selectedUserThumbnail)));
    } catch (e) {
      print(e.message);
    }
  }

  resentuser() {
    int count =0;

    FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString())
        .collection("chatlist").orderBy("timestamp",descending: true).get().then((value) =>

    {
      setState(() {
    count = value.docs.length;
      }),

      for(int i = 0; i< count.toInt(); i++){
        user.add(value.docs[i]["chatWith"].toString())
      },
      print("List : ${user.toString()}"),
      print(user.length),
      setState(() {
        ln=user.length;

      }),
    print("Length :${ln}"),

    });
  }

  void getContact() async {
    final snapshot = await FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts3').get();
    if(snapshot.docs.length == 0) {
      try {
        await Permission.contacts.request();
        final sw = Stopwatch()
          ..start();
        final contacts = await FastContacts.allContacts;
        sw.stop();
        _contacts = contacts;

        for (i = 0; i < _contacts.length; i++) {

          FirebaseFirestore.instance.collection("users").doc(
              _userik.uid.toString()).collection('contacts3').doc(i.toString()).set({
            'name': _contacts[i].displayName.toString(),
            'phone': _contacts[i].phones.first.toString(),



          });

        }
      }
      on PlatformException catch (e) {

      }
    }
    else {
      try {
        await Permission.contacts.request();
        final sw = Stopwatch()
          ..start();
        final contacts = await FastContacts.allContacts;
        sw.stop();
        _contacts = contacts;
        print(contacts.length.toString());
        for (i = 0; i < _contacts.length; i++) {
          FirebaseFirestore.instance.collection("users").doc(
              _userik.uid.toString()).collection('contacts2').doc(i.toString()).update({
            'name': _contacts[i].displayName.toString(),
            'phone': _contacts[i].phones.first.toString(),
            'phone2' :_contacts[i].phones.first.toString().substring(4,9)+ _contacts[i].phones.first.toString().substring(10)

          });
        }
      }
      on PlatformException catch (e) {

      }
    }



    }
  List<Contact> _contacts = const [];
  List phoneno =  [];
  phone() {
    int count =0;

    FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').get().then((value) =>

    {
      setState(() {
        count = value.docs.length;
      }),

      for(int i = 0; i< count.toInt(); i++){
        if(value.docs[i]["phone"].toString().contains("+91")){
          FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contac').doc(i.toString()).set(
              {
                'phone2' :value.docs[i]["phone"].toString().substring(4,9)+ value.docs[i]["phone"].toString().substring(10)

              }
              ),

        }

      },
      print("List : ${user.toString()}"),
      print(phoneno.length),
      setState(() {
        ln=phoneno.length;

      }),


    });
  }
  }











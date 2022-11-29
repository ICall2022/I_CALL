

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:i_call/Editprofile.dart';
import 'package:i_call/about.dart';

import 'package:i_call/chatlist2.dart';
import 'package:i_call/chatroom2.dart';
import 'package:i_call/sharenow.dart';

import 'package:i_call/terms.dart';
import 'package:i_call/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Controllers/fb_messaging.dart';

import 'Controllers/utils.dart';
import 'package:firestore_cache/firestore_cache.dart';


class recentscreen extends StatefulWidget {

  var nameuser;
  var Imgurl;
  int chatno;

  String phone;
  recentscreen(this.nameuser,this.Imgurl,this.chatno,this.phone);

  @override
  State<recentscreen> createState() => _recentscreenState();
}
User _userik = FirebaseAuth.instance.currentUser;

class _recentscreenState extends State<recentscreen> {


  void initState() {
    getContact();
    getContact2();
    _dataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String text) {
          setState(() {
            _sharedText = text;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Sharenow(_sharedText, _sharedFiles)));
        });

    //Receive text data when app is closed
    ReceiveSharingIntent.getInitialText().then((String text) {
      if (text != null) {

        setState(() {
          _sharedText = text;
        });


      }
    });

    //Receive files when app is running
    _dataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> files) {

      setState(() {
        _sharedFiles = files;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Sharenow("", _sharedFiles)));
    });

    //Receive files when app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {

      if (files != null) {
        setState(() {
          _sharedFiles = files;
        });

        if (_sharedFiles.map((f) => f.path).join(",") != null) {
        /*  Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Sharenow(_sharedText, _sharedFiles)));
          setState(() {
            _sharedFiles= null;
          });*/
        }

      }
    });


    super.initState();
    NotificationController.instance.updateTokenToServer();
  }


  @override
  void dispose() {
    super.dispose();
    _dataStreamSubscription.cancel();
  }


  StreamSubscription _dataStreamSubscription;

  String _sharedText = "";

  List<SharedMediaFile> _sharedFiles = null;




  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Text('I CALL'),
          ],
        ),
        actions: [

          Padding(
            padding: const EdgeInsets.only(top: 38.0,bottom: 18,right: 15.0),
            child: Container(
              width: 50,
              height: 20,

              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(20)

              ),
              child: PopupMenuButton<int>(
                  offset: Offset(0, 40),
                  color: Colors.white,
                  elevation: 2,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[


                    PopupMenuItem(
                      value: 0,


// row has two child icon and text
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=> EditProfile())
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children:const [
                                Icon(Icons.person,color: Colors.pinkAccent,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Edit Profile")
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),


                    PopupMenuItem(
                      value: 3,


// row has two child icon and text
                      child: GestureDetector(
                        onTap: (){
                         launch("https://docs.google.com/document/d/1WovldGAtlFXzJTjhxoqrinOA0ItXMryPz9aEdCq8xE4/edit?usp=sharing");
                        },
                        child: Column(
                          children: [
                            Row(
                              children:const [
                                Icon(Icons.text_snippet_outlined,color: Colors.pinkAccent,),
                                SizedBox(
// sized box with width 10
                                  width: 10,
                                ),
                                Text("T & C")
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if(value == 0){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> EditProfile())
                      );
                    }
                    else if(value == 1){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> About())
                      );

                    }
                    else if(value == 2){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> ContactPage())
                      );

                    }
                    else if(value == 3){
                      launch("https://docs.google.com/document/d/1WovldGAtlFXzJTjhxoqrinOA0ItXMryPz9aEdCq8xE4/edit?usp=sharing");


                    }


                  }),
            ),
          )
        ],
        toolbarHeight: 107,
        flexibleSpace: Container(
          height: 260,
          decoration: const BoxDecoration(
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
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => recentscreen(widget.nameuser,widget.Imgurl,widget.chatno,widget.phone)));

        },
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('Mycontacts').orderBy("timestamp",descending: true).snapshots(),
            builder: (context,  chaid) {
              if(!chaid.hasData){
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if(chaid.data.docs.length<1){
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 380.0),
                    child: Container(
                      child: Stack(

                        children: [
                          Image.asset("assets/newchat.png",),
                          const Padding (
                            padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 35),
                            child:  Text("Click here to start a \n new chat",textAlign: TextAlign.center,

                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),

                    ),
                  ),
                );
              }
              if (chaid.hasData != null) {
                return Stack(
                  children: [
                    ListView(
                        shrinkWrap: true,
                        children: chaid.data.docs.map((userData) {
                 return   Container(
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius
                                          .circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: userData['userImageUrl'],//data['userImageUrl'],
                                        placeholder: (context, url) => Container(
                                          transform:
                                          Matrix4.translationValues(0, 0, 0),
                                          child: Container(width: 60,height: 80,
                                              child: Center(child:new CircularProgressIndicator())),),
                                        errorWidget: (context, url, error) => new Icon(Icons.error),
                                        width: 60,height: 80,fit: BoxFit.cover,
                                      )
                                  ),
                                  title: Container(

                                    child: Text(userData['name'],overflow: TextOverflow.ellipsis,  maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight
                                              .bold),),
                                  ),
                                  subtitle: Container(
                                    child: Text(userData['lastchat'],overflow: TextOverflow.ellipsis,  maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xffE868A3).withOpacity(0.80),
                                      ),

                                      softWrap: false,),
                                  ),
                                  trailing: Padding(
                                      padding: const EdgeInsets
                                          .fromLTRB(0, 8, 4, 4),
                                      child: (chaid.hasData &&
                                          chaid.data.docs.length >
                                              0)
                                          ? Container(
                                        width: 60,
                                        height: 50,
                                        child: Column(
                                          children: <Widget>[
                                            Text((chaid.hasData &&
                                                chaid.data.docs
                                                    .length > 0)
                                                ? readTimestamp(
                                                chaid.data
                                                    .docs[0]['timestamp'])
                                                : '',
                                              style: TextStyle(
                                                  fontSize: size
                                                      .width *
                                                      0.03,
                                                color: Color(0xffE868A3),
                                                fontWeight: FontWeight.w400
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    0, 5, 0, 0),
                                                child: CircleAvatar(
                                                  radius: 9,
                                                  child: Text(
                                                    chaid.data
                                                        .docs[0]['badgeCount'] ==
                                                        null
                                                        ? ''
                                                        : ((chaid
                                                        .data
                                                        .docs[0]['badgeCount'] !=
                                                        0
                                                        ? '${chaid
                                                        .data
                                                        .docs[0]['badgeCount']}'
                                                        : '')),
                                                    style: TextStyle(
                                                        fontSize: 10),),
                                                  backgroundColor: chaid
                                                      .data
                                                      .docs[0]['badgeCount'] ==
                                                      null
                                                      ? Colors
                                                      .transparent
                                                      : (chaid.data
                                                      .docs[0]['badgeCount'] !=
                                                      0
                                                      ? Color(
                                                      0xffDF6DA2)
                                                      : Colors
                                                      .transparent),
                                                  foregroundColor: Colors
                                                      .white,
                                                )
                                            ),

                                          ],
                                        ),
                                      ) : Text('')),

                                  onTap: () {
                                    String chatID = makeChatId(_userik.uid.toString(), userData['userId']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (
                                                context) =>
                                                ChatRoom2(
                                                    _userik.uid.toString(),
                                                    widget.nameuser.toString(),
                                                    widget.Imgurl.toString(),
                                                    userData['FCMToken'],
                                                    userData['userId'],
                                                    chatID,
                                                    userData['name'],
                                                    userData['userImageUrl'],
                                                    userData['phone'],
                                                    "",
                                                    null,
                                                  widget.phone
                                                )));

                                  }
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  ),
                                child: Divider(),
                              )
                            ],
                          ),
                        ) );

                              }
                              ).toList()
              )
              ],
                );



              }
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }


        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add_comment) ,

        backgroundColor: Color(0xffE868A3),
        splashColor: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList2(contacts)));
        },
      ),

    );
  }

  getContact() async {

    try {
      await Permission.contacts.request();
      final sw = Stopwatch()
        ..start();
      final contact = await FastContacts.allContacts;
      sw.stop();
      contacts = contact;
      {

      }

      print(contact.length);

    }
    on PlatformException {

    }
  }
  getContact2() async {

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
  List<Contact> contacts = const [];
  List<Contact> _contacts = const [];
  int n =0;



}



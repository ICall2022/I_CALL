

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_call/Editprofile.dart';
import 'package:i_call/about.dart';
import 'package:i_call/chatconatct.dart';
import 'package:i_call/chatlist2.dart';
import 'package:i_call/chatroom2.dart';
import 'package:i_call/search.dart';
import 'package:i_call/terms.dart';
import 'package:i_call/contact.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/fb_messaging.dart';
import 'Controllers/image_controller.dart';
import 'Controllers/utils.dart';
import 'chatlist.dart';
import 'chatroom.dart';
import 'subWidgets/common_widgets.dart';
import 'subWidgets/local_notification_view.dart';

class recent extends StatefulWidget {


  @override
  State<recent> createState() => _recentState();
}
User _userik = FirebaseAuth.instance.currentUser;

class _recentState extends State<recent> {

  void initState() {
    super.initState();
    NotificationController.instance.updateTokenToServer();
    getData();
    getContact();
    userdetail();

  }

  var wheat1;
  var wheat2;
  var wheat3;
  var wheat4;
  var wheat5;
  var wheat6;
  getData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userik.uid.toString())
        .collection('chatlist')
        .get()
        .then((value) {

        wheat1 = value.docs[0].get('chatID');
      });

  }
  var nameuser;
  var Imgurl;
  userdetail() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_userik.uid.toString()).get();
    Map<String, dynamic> data = docSnapshot.data();
    nameuser = data['name'];
    Imgurl = data['userImageUrl'];
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width ;
    final size = MediaQuery.of(context).size;
    return Scaffold(
appBar: AppBar(
  automaticallyImplyLeading: false,
  title: Row(
    children: [



      Text('I CALL'),
    /*  Padding(
        padding:  EdgeInsets.only(left:140.0),
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=> CloudFirestoreSearch())
            );
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

 */
    ],
  ),
  actions: [

    Padding(
      padding: const EdgeInsets.only(top: 38.0,bottom: 38,right: 15.0),
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
                        children: [
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
                value: 1,


// row has two child icon and text
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> About())
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info,color: Colors.pinkAccent,),
                          SizedBox(
// sized box with width 10
                            width: 10,
                          ),
                          Text("About us")
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,


// row has two child icon and text
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> ContactPage())
                    );
                  },
                  child: Column(

                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone,color: Colors.pinkAccent,),
                          SizedBox(
// sized box with width 10
                            width: 10,
                          ),
                          Text("Contact us")
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> Terms())
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> Terms())
                );

              }


            }),
      ),
    )
  ],
  toolbarHeight: 127,
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
              Color(0xffFE67C4),
              Color(0xffFE67C4)
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('Mycontacts').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
            return Stack(
              children: [
                ListView(
                    shrinkWrap: true,
                    children: userSnapshot.data.docs.map((userData){
                      if (userData['userId'] == _userik.uid.toString()) {
                        return Container();
                      }
                      else {
                        return  StreamBuilder(

                          stream: FirebaseFirestore.instance
                              .collection('users').doc(_userik.uid.toString()).collection('chatlist').where('chatWith', isEqualTo: userData['userId'])
                              .snapshots(),


                          builder: (context ,chatid){
                            return Stack(
                              children: [
                                Container(
                                    child: (chatid.hasData && chatid.data.docs.length >0)
                                        ? chatid.data.docs[0]['chatWith'] == userData['userId'] ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: ImageController.instance.cachedImage(userData['userImageUrl']),
                                            ),
                                            title: Text(userData['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                            subtitle: Text((chatid.hasData && chatid.data.docs.length >0)
                                                ? chatid.data.docs[0]['lastChat']
                                                : userData['intro']),
                                            trailing: Padding(padding: const EdgeInsets.fromLTRB(0, 8, 4, 4),
                                                child: (chatid.hasData && chatid.data.docs.length > 0)
                                                    ? Container(
                                                  width: 60,
                                                  height: 50,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text((chatid.hasData && chatid.data.docs.length >0)
                                                          ? readTimestamp(chatid.data.docs[0]['timestamp'])
                                                          : '',style: TextStyle(fontSize: size.width * 0.03),
                                                      ),
                                                      Padding(
                                                          padding:const EdgeInsets.fromLTRB( 0, 5, 0, 0),
                                                          child: CircleAvatar(
                                                            radius: 9,
                                                            child: Text(chatid.data.docs[0]['badgeCount'] == null ? '' : ((chatid.data.docs[0]['badgeCount'] != 0
                                                                ? '${chatid.data.docs[0]['badgeCount']}'
                                                                : '')),
                                                              style: TextStyle(fontSize: 10),),
                                                            backgroundColor: chatid.data.docs[0]['badgeCount'] == null ? Colors.transparent : (chatid.data.docs[0]['badgeCount'] != 0
                                                                ? Color(0xffDF6DA2)
                                                                : Colors.transparent),
                                                            foregroundColor:Colors.white,
                                                          )
                                                      ),

                                                    ],
                                                  ),
                                                ) : Text('')),

                                            onTap: () => _moveTochatRoom(userData['FCMToken'],userData['userId'],userData['name'],userData['userImageUrl'],userData['phone']),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2.0,right: 8.0,left: 8.0),
                                            child: Divider(),
                                          )
                                        ],
                                      ),
                                    ): null : null ),




                              ],
                            );
                          },
                        );

                      }

                    }
                    ).toList()
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add_comment) ,

        backgroundColor: Color(0xffFE67C4),
        splashColor: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList2()));
        },
      ),

    );
  }

  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,selectedUserName, selectedUserThumbnail,phonenumber) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_userik.uid.toString()).get();
    Map<String, dynamic> data = docSnapshot.data();
    var name = data['name'];
    var Imgurl = data['userImageUrl'];


      try {
        String chatID = makeChatId(_userik.uid.toString(), selectedUserID);
     /*   Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatRoom2(
                        _userik.uid.toString(),
                        name.toString(),
                        Imgurl.toString(),
                        selectedUserToken,
                        selectedUserID,
                        chatID,
                        selectedUserName,
                        selectedUserThumbnail,
                        phonenumber,
                        first
                    )));*/
      } catch (e) {
        print(e.message);
      }
    }
    int i;
  void getContact() async {
    final snapshot = await FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').get();

    try {
      await Permission.contacts.request();
      final sw = Stopwatch()
        ..start();
      final contacts = await FastContacts.allContacts;
      sw.stop();
      _contacts = contacts;

      for (i = 0; i < _contacts.length; i++) {

        FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').doc(i.toString()).set({
          'name': _contacts[i].displayName.toString(),

          'phone':  _contacts[i].phones.first.toString() != "" ? _contacts[i].phones.first.toString().replaceAll(new RegExp(r'[^0-9]'),'') : "null"



        });

      }
    }
    on PlatformException catch (e) {

    }
  }
  List<Contact> _contacts = const [];
  }



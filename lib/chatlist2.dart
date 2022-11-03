

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_call/chatroom2.dart';



import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'Controllers/fb_messaging.dart';
import 'Controllers/image_controller.dart';
import 'Controllers/utils.dart';



import 'subWidgets/local_notification_view.dart';

class ChatList2 extends StatefulWidget {
  const ChatList2({Key key}) : super(key: key);



  @override _ChatList createState() => _ChatList();
}

class _ChatList extends State<ChatList2> with LocalNotificationView {

  @override
  void initState() {
    firsttime();
    userdetail();
    Mycontacts();
    super.initState();
    NotificationController.instance.updateTokenToServer();



    if (mounted) {
      checkLocalNotification(localNotificationAnimation, "");
    }
  }
  int first =0;
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
      setState(() {
        first =1;
      });


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
  var nameuser;
  var Imgurl;
  userdetail() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_userik.uid.toString()).get();
    Map<String, dynamic> data = docSnapshot.data();
     nameuser = data['name'];
     Imgurl = data['userImageUrl'];
  }
  String name = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: i ==0 ? AppBar(
          toolbarHeight: 90,
          backgroundColor: const Color(0xffF84F9D),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title:Row(
            children: [



              const   Text('Select a contact'),
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


          shape: const RoundedRectangleBorder(
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
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,

                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:const Icon(Icons.search, ), hintText: 'Search...'),
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
            decoration:const BoxDecoration(
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(37),
            ),
          ),
        ),
        body:  RefreshIndicator(
            onRefresh: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatList2()));

            },
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if(userSnapshot.hasData  ) {
                    return ListView(
                        shrinkWrap: true,
                        children: userSnapshot.data.docs.map((userData1) {
                          return StreamBuilder(
                              stream: (name != "" && name != null)
                                  ? FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection("contacts")
                                  .where('name', isGreaterThanOrEqualTo: name).where('name', isLessThan: name + 'z').snapshots()
                                  : FirebaseFirestore.instance.collection('users')
                                  .doc(_userik.uid.toString())
                                  .collection("contacts")
                                  .snapshots(),
                              builder: (context, AsyncSnapshot<
                                  QuerySnapshot> snapshots) {


                                  return ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: snapshots.data.docs.map((
                                          userData) {
                                        if (userData['phone'].toString().length >= 10) {
                                          return userData1['phone'].contains(userData['phone'].toString().substring(2)) ? Padding(
                                            padding: const EdgeInsets.all(
                                                8.0),
                                            child: ListTile(

                                                leading: ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(15),
                                                  child: ImageController
                                                      .instance.cachedImage(
                                                      userData1['userImageUrl']),
                                                ),
                                                title: Text(userData['name'],
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .bold),),


                                                onTap: () {
                                                  print(
                                                      "name ${userData['name']}");
                                                  String chatID = makeChatId(_userik.uid.toString(), userData1['userId']);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (
                                                              context) =>
                                                              ChatRoom2(
                                                                  _userik.uid.toString(),
                                                                  name.toString(),
                                                                  Imgurl.toString(),
                                                                  userData1['FCMToken'],
                                                                  userData1['userId'],
                                                                  chatID,
                                                                  userData['name'],
                                                                  userData1['userImageUrl'],
                                                                  userData1['phone'],
                                                                   first
                                                              )));
                                                }),
                                          ) : const SizedBox();
                                        }
                                        else {
                                          return userData1['phone'].contains(
                                              userData['phone'].toString())
                                              ? Padding(
                                            padding: const EdgeInsets.all(
                                                8.0),
                                            child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                                child: ImageController
                                                    .instance
                                                    .cachedImage(
                                                    userData1['userImageUrl']),
                                              ),
                                              title: Text(userData['name'],
                                                style:const TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight
                                                        .bold),),


                                              onTap: () {
                                               // print("name ${userData['name']}");
                                                String chatID = makeChatId(_userik.uid.toString(), userData1['userId']);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatRoom2(
                                                                _userik.uid.toString(),
                                                                name.toString(),
                                                                Imgurl.toString(),
                                                                userData1['FCMToken'],
                                                                userData1['userId'],
                                                                chatID,
                                                                userData['name'],
                                                                userData1['userImageUrl'],
                                                                userData1['phone'],
                                                                first)));
                                              },
                                            ),
                                          )
                                              : SizedBox();
                                        }
                                      }).toList()
                                  );

                              }
                          );
                        }).toList()

                    );
                  }
               return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                ),
            )
    );
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





  Mycontacts() async {
    int i;
    var document = await  FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').get();
    var docu = await  FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).collection('contacts').get();
    var allusers = await  FirebaseFirestore.instance.collection("users").get();

    if(first!=2){
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


}











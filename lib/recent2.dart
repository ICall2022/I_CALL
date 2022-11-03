

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:i_call/Editprofile.dart';
import 'package:i_call/about.dart';

import 'package:i_call/chatlist2.dart';
import 'package:i_call/chatroom2.dart';

import 'package:i_call/terms.dart';
import 'package:i_call/contact.dart';

import 'Controllers/fb_messaging.dart';

import 'Controllers/utils.dart';


class recent2 extends StatefulWidget {
  int first;
  var nameuser;
  var Imgurl;
  int chatno;
  recent2(this.first,this.nameuser,this.Imgurl,this.chatno);

  @override
  State<recent2> createState() => _recent2State();
}
User _userik = FirebaseAuth.instance.currentUser;

class _recent2State extends State<recent2> {


  void initState() {
    super.initState();
    NotificationController.instance.updateTokenToServer();
  }









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
                              children: const [
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
                              children: const [
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
          decoration: const BoxDecoration(
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
      body: widget.chatno == 1 ? RefreshIndicator(
        onRefresh: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => recent2(widget.first,widget.nameuser,widget.Imgurl,widget.chatno)));

        },
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('Mycontacts').orderBy("timestamp",descending: true).snapshots(),
            builder: (context,  userSnapshot) {
              if (userSnapshot.hasData != null) {
                return Stack(
                  children: [
                    ListView(
                        shrinkWrap: true,
                        children: userSnapshot.data.docs.map((userData) {
                          if (userData['userId'] == _userik.uid.toString()) {
                            return Container();
                          }
                          else {
                            return StreamBuilder(

                              stream: FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString())
                                  .collection('chatlist').where('chatWith', isEqualTo: userData['userId'])
                                  .snapshots(),


                              builder: (context, chatid) {
                                if (chatid.hasData != null){
                                return Stack(
                                  children: [
                                    Container(
                                        child: (chatid.hasData &&
                                            chatid.data.docs.length > 0)
                                            ? chatid.data.docs[0]['chatWith'] ==
                                            userData['userId'] ? Padding(
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
                                                  child: Text((chatid.hasData &&
                                                      chatid.data.docs.length > 0)
                                                      ? chatid.data
                                                      .docs[0]['lastChat']
                                                      : userData['intro'],overflow: TextOverflow.ellipsis,  maxLines: 1,
                                                    softWrap: false,),
                                                ),
                                                trailing: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 4, 4),
                                                    child: (chatid.hasData &&
                                                        chatid.data.docs.length >
                                                            0)
                                                        ? Container(
                                                      width: 60,
                                                      height: 50,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text((chatid.hasData &&
                                                              chatid.data.docs
                                                                  .length > 0)
                                                              ? readTimestamp(
                                                              chatid.data
                                                                  .docs[0]['timestamp'])
                                                              : '',
                                                            style: TextStyle(
                                                                fontSize: size
                                                                    .width *
                                                                    0.03),
                                                          ),
                                                          Padding(
                                                              padding: const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                              child: CircleAvatar(
                                                                radius: 9,
                                                                child: Text(
                                                                  chatid.data
                                                                      .docs[0]['badgeCount'] ==
                                                                      null
                                                                      ? ''
                                                                      : ((chatid
                                                                      .data
                                                                      .docs[0]['badgeCount'] !=
                                                                      0
                                                                      ? '${chatid
                                                                      .data
                                                                      .docs[0]['badgeCount']}'
                                                                      : '')),
                                                                  style: TextStyle(
                                                                      fontSize: 10),),
                                                                backgroundColor: chatid
                                                                    .data
                                                                    .docs[0]['badgeCount'] ==
                                                                    null
                                                                    ? Colors
                                                                    .transparent
                                                                    : (chatid.data
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
                                                                  widget.first)));

                                                 }
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 2.0,
                                                    right: 8.0,
                                                    left: 8.0),
                                                child: Divider(),
                                              )
                                            ],
                                          ),
                                        ) : null : null),


                                  ],
                                );}
                                if(chatid.hasData ==  null){
                                  return Text("No error Data");
                                }
                               return Text("No User Data");
                              },
                            );
                          }
                        }
                        ).toList()
                    ),


                  ],
                );
              }
              if(userSnapshot.hasData ==  null){
                return Text("No error Data");
              }
              if(userSnapshot.hasError){
                return Text("No error Data");
              }
              return Text("No User hi");
            }

            ),
      ) : RefreshIndicator(
        onRefresh: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => recent2(widget.first,widget.nameuser,widget.Imgurl,widget.chatno)));

        },
        child: Center(
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
            ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add_comment) ,

        backgroundColor: Color(0xffFE67C4),
        splashColor: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList2()));
        },
      ),

    );
  }


}



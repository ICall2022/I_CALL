import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/fb_firestore.dart';
import 'Controllers/fb_messaging.dart';
import 'Controllers/fb_storage.dart';
import 'Controllers/image_controller.dart';
import 'Controllers/utils.dart';
import 'subWidgets/chatListTile/mine_list_tile.dart';
import 'subWidgets/chatListTile/peer_user_list_tile.dart';
import 'subWidgets/chatListTile/string_list_tile.dart';
import 'subWidgets/common_widgets.dart';
import 'subWidgets/local_notification_view.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(this.myID,this.myName,this.myImageUrl,this.selectedUserToken, this.selectedUserID, this.chatID, this.selectedUserName, this.selectedUserThumbnail);

  String myID;
  String myName;
  String myImageUrl;
  String selectedUserToken;
  String selectedUserID;
  String chatID;
  String selectedUserName;
  String selectedUserThumbnail;

  @override _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver,LocalNotificationView {
  Timestamp  timestamp= Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 2)));
  final TextEditingController _msgTextController = new TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _chatListController = ScrollController();
  String messageType = 'text';
  int chatListLength = 20;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState');
    setState(() {
      switch(state) {
        case AppLifecycleState.resumed:
          FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,true);
          print('AppLifecycleState.resumed');
          break;
        case AppLifecycleState.inactive:
          print('AppLifecycleState.inactive');
          FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,false);
          break;
        case AppLifecycleState.paused:
          print('AppLifecycleState.paused');
          FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,false);
          break;
        case AppLifecycleState.detached:
          // TODO: Handle this case.
          break;
      }
    });
  }
  bool status = false;
  int a=0;
  User _userik = FirebaseAuth.instance.currentUser;

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
         a=1;
              });

    }

  }
  Future checkDocuement() async {
    final snapShot = await FirebaseFirestore.instance.
         collection('chatroom')
        .doc(widget.chatID) // varuId in your case
        .get();

   if (snapShot['status'] == "save") {
    print('Cannot Delete');
    setState(() {
      status=true;
    });


  }
   else if(snapShot['status'] == "not"){
     deleteFile();
     setState(() {
       status=false;
     });

  }

  }
  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    print('_onEmojiSelected: ${emoji.emoji}');
  }

  _onBackspacePressed() {
    print('_onBackspacePressed');
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,true);
    print(timestamp.millisecondsSinceEpoch.toString());
    firsttime();
    checkDocuement();
    print(status.toString());

    if(status == false){

    }




    if(mounted){
      isShowLocalNotification = true;
      _savedChatId(widget.chatID);
      checkLocalNotification(localNotificationAnimation,widget.chatID);
    }
  }

  void localNotificationAnimation(List<dynamic> data){
    if(mounted){
      setState(() {
        if(data[1] == 1.0){
          localNotificationData = data[0];
        }
        localNotificationAnimationOpacity = data[1] as double;
      });
    }
  }

  Future<void> _savedChatId(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("inRoomChatId", value);
  }

  @override
  void dispose() {
    _msgTextController.dispose();
    isShowLocalNotification = false;
    FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,false);
    _savedChatId("");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Future savechat() async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.chatID).update(
        {
      "status": "not",


    },);



  }
  Future savechat1() async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.chatID).update(
        {
      "status": "save",


    },);



  }
  int sub = 0;
  Future sup() async {
    var cdate =  await FirebaseFirestore.instance.collection("chatroom").doc(widget.chatID).get();
    if(cdate['status']== "save"){
      setState(() {
        sub=1;
      });
    }
   else {
      // Collection not exits
      return false;
    }
  }
  bool isSwitched = false;
  Future<void> _showMyDialog1() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Do you want to save this chat ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This action will save your chat here after' ),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: const Text('Save Chat',style: TextStyle(color: Colors.blue),),
              onPressed: () {
                savechat1();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => ChatRoom(widget.myID, widget.myName, widget.myImageUrl, widget.selectedUserToken, widget.selectedUserID, widget.chatID, widget.selectedUserName, widget.selectedUserThumbnail)));
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showMyDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Are you sure of disabling the save chat ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This action will delete all your chat happened in past' ),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: const Text('Disable Chat',style: TextStyle(color: Colors.blue),),
              onPressed: () {
               savechat();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ChatRoom(widget.myID, widget.myName, widget.myImageUrl, widget.selectedUserToken, widget.selectedUserID, widget.chatID, widget.selectedUserName, widget.selectedUserThumbnail)));
                },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SafeArea(
        top:false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back_ios_rounded)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    height: 50,

                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(widget.selectedUserThumbnail))

                  ),
                ),
                Text(widget.selectedUserName),

              ],
            ),
            actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 50,
              height: 50,

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

                  status == true?        PopupMenuItem(
                    value: 1,
                    onTap: (){

                      Future.delayed(
                          const Duration(seconds: 0),
                              () => _showMyDialog2()

                      );
                    },

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.download_done_outlined,color: Colors.pinkAccent,),
                            SizedBox(
// sized box with width 10
                              width: 10,
                            ),
                            Text("Chat is Saved")
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ) : PopupMenuItem(
                    onTap: (){
                      Future.delayed(
                          const Duration(seconds: 0),
                              () => _showMyDialog1()

                      );
                    },
                    value: 2,
// row has two child icon and text
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.monitor_heart,color: Colors.pinkAccent,),
                            SizedBox(
// sized box with width 10
                              width: 10,
                            ),
                            Text("Save Chat")
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,


// row has two child icon and text
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person,color: Colors.pinkAccent,),
                            SizedBox(
// sized box with width 10
                              width: 10,
                            ),
                            Text("View Contact")
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {

                }),
            ),
          )
            ],
            toolbarHeight: 67,
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
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot> (
              stream: FirebaseFirestore.instance.
                  collection('chatroom').
                  doc(widget.chatID).
                  collection(widget.chatID).
                  orderBy('timestamp',descending: false).
                  snapshots(),
              builder: (context,snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        a==0? Text("First") : Container(),

                        Expanded(
                          child: ListView(
                            reverse: true,
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(4.0,10,4,10),
                            controller: _chatListController,
                            children: addInstructionInSnapshot(snapshot.data.docs).map(_returnChatWidget).toList()
                          ),
                        ),
                        _buildTextComposer(),
                      ],
                    ),
                    localNotificationCard(size)
                  ],
                );
              }
            ),
          ),
      ),
    );
    // );
  }

  Widget _returnChatWidget(dynamic data){
    Widget _returnWidget;

    if(data is QueryDocumentSnapshot){
      if(data['idTo'] == widget.myID && data['isread'] == false) {
        if (data.reference != null) {
          FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
            await myTransaction.update(data.reference, {'isread': true});
          });
        }
      }

      _returnWidget = data['idFrom'] == widget.selectedUserID ? peerUserListTile(context,
          widget.selectedUserName,
          widget.selectedUserThumbnail,
          data['content'],
          returnTimeStamp(data['timestamp']),
          data['type']) :
      mineListTile(context,
          data['content'],
          returnTimeStamp(data['timestamp']),
          data['isread'],
          data['type']);
    }else if(data is String){
      _returnWidget = stringListTile(data);
    }
    return _returnWidget;
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0,left: 15.0,right: 15.0,bottom: 30),
        child: Column(
          children: [
            new Container(
              height: 67,
             width: 366,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(25),
               color: Color(0xffF8E6EE)
             ),
              child: new Row(
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 2.0),
                    child: new IconButton(
                        icon: new Icon(Icons.emoji_emotions_outlined,color: Color(0xffFC1982),),
                        onPressed: () {
                          setState(() {
                            emojiShowing = !emojiShowing;
                          });


                        }),
                  ),
                  new Flexible(
                    child: new TextField(
                      controller: _msgTextController,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                          hintText: "Send a message"),
                    ),
                  ),
                  RotationTransition(
                    turns: AlwaysStoppedAnimation(30 / 360),
                    child: new Container(


                      margin: new EdgeInsets.symmetric(horizontal: 2.0),
                      child: new IconButton(

                          icon: new Icon(Icons.attach_file_rounded,color: Color(0xffFC1982),),
                          onPressed: () {

                            ImageController.instance.cropImageFromFile().then((croppedFile) {
                              if (croppedFile != null) {
                                setState(() { messageType = 'image'; });
                                _saveUserImageToFirebaseStorage(croppedFile);
                              }else {
                                showAlertDialog(context,'Pick Image error');
                              }
                            }
                            );

                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 8,right: 8,left: 1),
                    child: new Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xffFC1982),
                      ),
                      margin: new EdgeInsets.symmetric(horizontal: 2.0),
                      child: GestureDetector(
                        onTap: (){
                           setState(() { messageType = 'text'; });
                                 _handleSubmitted(_msgTextController.text);
                               },

                        child:  Image.asset("assets/send.png"),
                    ),
                  ),
                ),
                ]
              ),
            ),

            Offstage(
              offstage: !emojiShowing,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(

                      textEditingController: _msgTextController,
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Color(0xffFC1982),
                          iconColor: Colors.grey,
                          iconColorSelected: Color(0xffFC1982),
                          progressIndicatorColor: Color(0xffFC1982),
                          backspaceColor: Color(0xffFC1982),
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style: TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveUserImageToFirebaseStorage(croppedFile) async {
    try {
      String takeImageURL = await FBStorage.instanace.sendImageToUserInChatRoom(croppedFile,widget.chatID);
      _handleSubmitted(takeImageURL);
    }catch(e) {
      showAlertDialog(context,'Error add user image to storage');
    }
  }

  Future<void> _handleSubmitted(String text) async {
    try {
      await FBCloudStore.instanace.sendMessageToChatRoom(widget.chatID,widget.myID,widget.selectedUserID,text,messageType);
      await FBCloudStore.instanace.updateUserChatListField(widget.selectedUserID, messageType == 'text' ? text : '(Photo)',widget.chatID,widget.myID,widget.selectedUserID);
      await FBCloudStore.instanace.updateUserChatListField(widget.myID, messageType == 'text' ? text : '(Photo)',widget.chatID,widget.myID,widget.selectedUserID);
      _getUnreadMSGCountThenSendMessage();
    }catch(e){
      showAlertDialog(context,'Error user information to database');
      _resetTextFieldAndLoading();
    }
  }

  Future<void> _getUnreadMSGCountThenSendMessage() async{
    try {
      int unReadMSGCount = await FBCloudStore.instanace.getUnreadMSGCount(widget.selectedUserID);
      await NotificationController.instance.sendNotificationMessageToPeerUser(unReadMSGCount, messageType, _msgTextController.text, widget.myName, widget.chatID, widget.selectedUserToken,widget.myImageUrl);
    }catch(e) {
      print(e.message);
    }
    _resetTextFieldAndLoading();
  }

  void _resetTextFieldAndLoading() {
    FocusScope.of(context).requestFocus(FocusNode());
    _msgTextController.text = '';
  }

  Future deleteFile() async {
    await _firestore
        .collection('chatroom').
         doc(widget.chatID).
         collection(widget.chatID).
         where('timestamp',isLessThanOrEqualTo:timestamp.millisecondsSinceEpoch).get().
       then((value) => value.docs.forEach((doc) {
          doc.reference.delete();
    }));

  }
  Future update() async {
    await _firestore
        .collection('chatroom').
         doc(widget.chatID).
         collection(widget.chatID).
    doc("Status").set(

      {
        'save' : "true"

      }
    );




  }
  Future update1() async {
    await _firestore
        .collection('chatroom').
         doc(widget.chatID).
         collection(widget.chatID).
         doc("Status").update(

      {
        'save' : "false"

      }
    );




  }
}


import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_call/viewprofile.dart';
import 'package:lottie/lottie.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
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


class ChatRoom2 extends StatefulWidget {
  ChatRoom2(this.myID,this.myName,this.myImageUrl,this.selectedUserToken, this.selectedUserID, this.chatID, this.selectedUserName, this.selectedUserThumbnail,this.phonenumber,this.message,this.fileimg,this.myphone,{Key key}) : super(key: key);

  String myID;
  String myName;
  String myImageUrl;
  String selectedUserToken;
  String selectedUserID;
  String chatID;
  String selectedUserName;
  String selectedUserThumbnail;
  String phonenumber;
  String message;
  String myphone;
  List<SharedMediaFile> fileimg;


  @override _ChatRoom2State createState() => _ChatRoom2State();
}

class _ChatRoom2State extends State<ChatRoom2> with WidgetsBindingObserver,LocalNotificationView {
  Timestamp  timestamp= Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 10)));
    TextEditingController _msgTextController =   new TextEditingController();
   FirebaseFirestore _firestore = FirebaseFirestore.instance;
   ScrollController _chatListController = ScrollController();
  String messageType = 'text';
  int chatListLength = 20;
  var date = new DateTime.now();
  bool _isLoading = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
     // //print('didChangeAppLifecycleState');
    setState(() {
      switch(state) {
        case AppLifecycleState.resumed:
          FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,true);
      //    //print('AppLifecycleState.resumed');
          break;
        case AppLifecycleState.inactive:
          //print('AppLifecycleState.inactive');
          FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,false);
          break;
        case AppLifecycleState.paused:
          //print('AppLifecycleState.paused');
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
  String mynameon = "Demo";

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
      //print('Cannot Delete');
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
    //print('_onEmojiSelected: ${emoji.emoji}');
  }

  _onBackspacePressed() {
    //print('_onBackspacePressed');
  }

  myname() async {
    var  document = await FirebaseFirestore.instance.collection('users').doc(widget.selectedUserID).collection('Mycontacts').doc(widget.myID).get();
    Map<String,dynamic> value = document.data();
    setState(() {
      mynameon = value['name'];

    });
  }


  @override
  void initState() {
    setState(() {
      widget.message !=""?
      _msgTextController.text = widget.message: null;
    });
    widget.fileimg != null?
    ImageController3.instance.cropImageFromFile2(widget.fileimg).then((croppedFile) {
      if (croppedFile != null) {
        setState(() { messageType = 'image'; });
        _saveUserImageToFirebaseStorage(croppedFile);
      }else {

      }
    }
    ): null;
    print("NMAEEEEEEE:${widget.fileimg.toString()}");
    myname();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FBCloudStore.instanace.updateMyChatListValues(widget.myID,widget.chatID,true);
    //print(timestamp.millisecondsSinceEpoch.toString());
    firsttime();
    checkDocuement();
    //print(status.toString());

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
        .doc(widget.chatID).set(
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
          title:  const TextResponsive('Do you want to save this chat ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                ContainerResponsive(
                    width: 200,
                    height: 200,
                    child: Lottie.asset("assets/Savechat.json")
                ),
                TextResponsive('This action will save your chat here after'),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: const TextResponsive('Save Chat',style: TextStyle(color: Colors.blue),),
              onPressed: () {
                savechat1();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => ChatRoom2(widget.myID, widget.myName, widget.myImageUrl, widget.selectedUserToken, widget.selectedUserID, widget.chatID, widget.selectedUserName, widget.selectedUserThumbnail,widget.phonenumber,widget.message,widget.fileimg,widget.myphone)));
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
          title:  const TextResponsive('Are you sure of disabling the save chat ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                ContainerResponsive(
                    width: 200,
                    height: 200,
                    child: Lottie.asset("assets/AREYOUSURE.json")
                ),
                TextResponsive('This action will delete all your chat happened in past' ),

              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: const TextResponsive('Disable Chat',style: TextStyle(color: Colors.blue),),
              onPressed: () {
                savechat();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => ChatRoom2(widget.myID, widget.myName, widget.myImageUrl, widget.selectedUserToken, widget.selectedUserID, widget.chatID, widget.selectedUserName, widget.selectedUserThumbnail,widget.phonenumber,widget.message,widget.fileimg,widget.myphone)));
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
    ResponsiveWidgets.init(
      context,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      allowFontScaling: false,
    );
    return ResponsiveWidgets.builder(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      allowFontScaling: false,
      child: ContainerResponsive(
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
                  }, icon: const Icon(Icons.arrow_back_ios_rounded)),
                  Padding(
                    padding:  EdgeInsetsResponsive.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  ViewProfile(widget.selectedUserThumbnail,
                                      widget.selectedUserName,
                                      widget.phonenumber))
                          );
                        },
                      child: ContainerResponsive(
                          width: 50,
                          height: 50,

                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ImageController2.instance
                                  .cachedImage(widget.selectedUserThumbnail))

                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> ViewProfile(widget.selectedUserThumbnail,widget.selectedUserName,widget.phonenumber))
                        );

                      },
                      child: ContainerResponsive(
                          padding:  EdgeInsetsResponsive.only(right: 30.0),
                          child: TextResponsive(widget.selectedUserName.toString(), overflow: TextOverflow.ellipsis,  maxLines: 1,
                            softWrap: false,)),
                    ),
                  ),

                ],
              ),
              actions: [
                Padding(
                  padding:  EdgeInsetsResponsive.all(8.0),
                  child: ContainerResponsive(
                    width: 50,
                    height: 50,

                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(20)

                    ),
                    child: PopupMenuButton<int>(
                        offset: const Offset(0, 40),
                        color: Colors.white, 
                        elevation: 2,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[

                          status == true?        PopupMenuItem(
                            value: 3,


                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.download_done_outlined,color: Colors.pinkAccent,),
                                    SizedBox(
// sized box with width 10
                                      width: 10,
                                    ),
                                    TextResponsive("Chat is Saved")
                                  ],
                                ),
                                const  Divider(),
                              ],
                            ),
                          ) : PopupMenuItem(

                            value: 2,
// row has two child icon and text
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.monitor_heart,color: Colors.pinkAccent,),
                                    SizedBox(
// sized box with width 10
                                      width: 10,
                                    ),
                                    TextResponsive("Save Chat")
                                  ],
                                ),
                                const   Divider(),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,



                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                     Icon(Icons.person,color: Colors.pinkAccent,),
                                      SizedBox(
// sized box with width 10
                                      width: 10,
                                    ),
                                    TextResponsive("View Contact")
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if(value == 2){
                            Future.delayed(
                                const Duration(seconds: 0),
                                    () => _showMyDialog1());

                          }
                          else if(value == 1){

                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> ViewProfile(widget.selectedUserThumbnail,widget.selectedUserName,widget.phonenumber))
                              );
                          }
                          else if(value == 3){
                            Future.delayed(
                                const Duration(seconds: 0),
                                    () => _showMyDialog2());


                          }
                        }

                    ),
                  ),
                )
              ],
              toolbarHeight: 67,
              flexibleSpace: ContainerResponsive(
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
                  if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());
                  return Stack(
                    children: <Widget>[
                      Column(

                        children: <Widget>[


                          Expanded(
                            child: ListView(
                                reverse: true,
                                shrinkWrap: true,
                                padding:  EdgeInsetsResponsive.fromLTRB(4.0,10,4,10),
                                controller: _chatListController,
                                children: addInstructionInSnapshot(snapshot.data.docs).map(_returnChatWidget).toList()
                            ),
                          ),
                          _isLoading == true ?  Padding(
                            padding:  EdgeInsetsResponsive.only(left: 170.0,right: 10),
                            child: ContainerResponsive(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                gradient:  LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color(0xffF39EC4),
                                      Color(0xffF39EC4)
                                    ]),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding:  EdgeInsetsResponsive.all(4.0),
                                child: ContainerResponsive(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      gradient:  LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            Color(0xffF39EC4),
                                            Color(0xffF39EC4)
                                          ]),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: loadingCircle(true)),
                              ),
                            ),
                          ) : ContainerResponsive(),
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
    return IconTheme(
      data:  IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Padding(
        padding:  EdgeInsetsResponsive.only(top: 12.0,left: 15.0,right: 15.0,bottom: 30),
        child: Column(
          children: [
            ContainerResponsive(
              height: 67,
              width: 366,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xffF8E6EE)
              ),
              child: Row(
                  children: <Widget>[
                     ContainerResponsive(
                      margin:  EdgeInsetsResponsive.symmetric(horizontal: 2.0),
                      child:  IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined,color: Color(0xffFC1982),),
                          onPressed: () {
                            setState(() {
                              emojiShowing = !emojiShowing;
                            });


                          }),
                    ),
                     Flexible(
                      child:  TextField(
                        controller: _msgTextController,
                        onSubmitted: _handleSubmitted,
                        decoration: const InputDecoration.collapsed(
                            hintText: "Send a message"),
                      ),
                    ),
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(30 / 360),
                      child:  ContainerResponsive(


                        margin:  EdgeInsetsResponsive.symmetric(horizontal: 2.0),
                        child:  IconButton(

                            icon:  Icon(Icons.attach_file_rounded,color: Color(0xffFC1982),),
                            onPressed: () {
                              print("oki");

                              ImageController2.instance.cropImageFromFile().then((croppedFile) {
                                if (croppedFile != null) {
                                  setState(() {
                                    messageType = 'image';
                                   _isLoading=true;
                                  });
                                  _saveUserImageToFirebaseStorage(croppedFile);
                                }else {

                                }
                              }
                              );

                            }),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsetsResponsive.only(top:8.0,bottom: 8,right: 8,left: 1),
                      child:  ContainerResponsive(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xffFC1982),
                        ),
                        margin:  EdgeInsetsResponsive.symmetric(horizontal: 2.0),
                        child: GestureDetector(
                          onTap: (){

                            setState(() { messageType = 'text'; });

                            _handleSubmitted(_msgTextController.text);
                            Updaterecent();
                            _getUnreadMSGCountThenSendMessage();
                            FirebaseFirestore.instance
                                .collection('chatroom')
                                .doc(widget.chatID)
                                .collection(widget.chatID)
                                .doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
                              'idFrom': _userik.uid,
                              'idTo': widget.selectedUserID,
                              'timestamp': DateTime.now().millisecondsSinceEpoch,
                              'content': _msgTextController.text,
                              'type':messageType,
                              'isread':false,
                              'time': date.hour,

                            });






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
                padding:  EdgeInsetsResponsive.only(top: 8.0),
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
                          gridPadding: EdgeInsetsResponsive.zero,
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
                          noRecents: const TextResponsive(
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

  Future<void> _handleSubmitted(String text)  {

    try {

       FBCloudStore.instanace.sendMessageToChatRoom(widget.chatID,widget.myID,widget.selectedUserID,text,messageType);
       FBCloudStore.instanace.updateUserChatListField(widget.selectedUserID, messageType == 'text' ? text : '(Photo)',widget.chatID,widget.myID,widget.selectedUserID);
       FBCloudStore.instanace.updateUserChatListField(widget.myID, messageType == 'text' ? text : '(Photo)',widget.chatID,widget.myID,widget.selectedUserID);

      setState(() {
        _isLoading=false;
      });
    }catch(e){
      showAlertDialog(context,'Error user information to database');

    }
  }

  Future<void> _getUnreadMSGCountThenSendMessage() async{
    try {
      int unReadMSGCount = await FBCloudStore.instanace.getUnreadMSGCount(widget.selectedUserID);
      await NotificationController.instance.sendNotificationMessageToPeerUser(unReadMSGCount, messageType, _msgTextController.text, mynameon, widget.chatID, widget.selectedUserToken,widget.myImageUrl);
    }catch(e) {
      print(e.message);
    }

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
  String nameuser;
  String Imgurl;
  String phone;
  Updaterecent() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_userik.uid.toString()).get();
    Map<String, dynamic> data = docSnapshot.data();
    nameuser = data['name'];
    Imgurl = data['userImageUrl'];
    phone =data['phone'];

    FirebaseFirestore.instance.collection("users").doc(
        _userik.uid.toString()).collection('Mycontacts').doc(widget.selectedUserID).set({
      'name':widget.selectedUserName,
      'userId': widget.selectedUserID,
      'FCMToken': widget.selectedUserToken,
      'userImageUrl': widget.selectedUserThumbnail,
      'phone': widget.phonenumber,
      "lastchat":_msgTextController.text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'recent': true,
      'badgeCount': isRoom ? 0 : userBadgeCount,



    }
    );
    FirebaseFirestore.instance.collection("users").doc(widget.selectedUserID
        ).collection('Mycontacts').doc(_userik.uid.toString()).set({
      'name':nameuser,
      'userId': _userik.uid.toString(),
      'FCMToken': widget.myID,
      'userImageUrl': Imgurl,
      'phone': phone,
      "lastchat":_msgTextController.text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'recent': true,
      'badgeCount': isRoom ? 0 : userBadgeCount,



    });
    _msgTextController.clear();
  }
  var isRoom = false;
  var userBadgeCount = 0;
}
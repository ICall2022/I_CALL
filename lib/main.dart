import 'dart:async';
import 'dart:io';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/Welcome.dart';
import 'package:i_call/login.dart';
import 'package:i_call/recent2.dart';
import 'package:i_call/recentscreen.dart';
import 'package:i_call/subWidgets/common_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'Controllers/fb_auth.dart';
import 'Controllers/fb_firestore.dart';
import 'Controllers/fb_messaging.dart';
import 'Controllers/fb_storage.dart';
import 'Controllers/image_controller.dart';
import 'Controllers/utils.dart';
import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_call/chatroom2.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/fb_messaging.dart';
import 'Controllers/image_controller.dart';
import 'Controllers/utils.dart';
import 'Home.dart';
import 'chatroom.dart';
import 'subWidgets/common_widgets.dart';
import 'subWidgets/local_notification_view.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    badge: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I CALL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.pink,
      ),
      home: FirebaseAuth.instance.currentUser == null ?

      WelcomeScreen() : splashscreen(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  final String Phone;
  MyHomePage(this.Phone);

  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _introTextController = TextEditingController();
  File _userImageFile = File('');
  String _userImageUrlFromFB = '';

  bool _isLoading = false;
  User _user;
  String _userId;

  @override
  void initState() {
    super.initState();
    NotificationController.instance.takeFCMTokenWhenAppLaunch();
    NotificationController.instance.initLocalNotification();
    setState(() {
      _introTextController.text=widget.Phone.toString();
    });
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if(user != null){
        _userId = user.uid;
        _takeUserInformationFromFBDB(user);
      }else{
        setState(() {

        });
      }
    });
  }

  _takeUserInformationFromFBDB(User user) async {
    FBCloudStore.instanace.takeUserInformationFromFBDB().then((documents) {
      if (documents.length > 0) {
        _emailTextController.text = documents[0]['email'] ?? '';
        _nameTextController.text = documents[0]['name'];
        _introTextController.text = documents[0]['intro'];
        _userId = documents[0]['userId'];

        setState(() {
          _userImageUrlFromFB = documents[0]['userImageUrl'];
        });
      }
      setState(() {
        _isLoading = false;
      });
    });
  }
  User _userik = FirebaseAuth.instance.currentUser;
  String name;
  void onchanged(String value){
    setState(() {
      name= value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back_ios_rounded)),

            Text("Edit your profile"),

          ],
        ),

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
      body:
      Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [




                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              child: Container(
                                width: 150,
                                height: 150,
                                child: ClipRRect(

                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                  _userImageUrlFromFB != ''
                                      ? Image.network(_userImageUrlFromFB,fit: BoxFit.cover,)
                                      : (_userImageFile.path != '')
                                      ? Image.file(_userImageFile,
                                      fit: BoxFit.fill)
                                      : Icon(Icons.add_photo_alternate,
                                      size: 60, color: Colors.grey[700]),

                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                ImageController.instance.cropImageFromFile().then((croppedFile) {
                                  if (croppedFile != null) {
                                    setState(() {
                                      _userImageFile = croppedFile;
                                      _userImageUrlFromFB = '';
                                    });
                                  } else {
                                    showAlertDialog(context,'Pick Image error');
                                  }
                                });
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: const Offset(
                                        5.0,
                                        5.0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],

                                ),
                                child: Center(
                                  child: Image.asset("assets/pen.png",scale: 30,),
                                ),
                              ),
                            ),
                          ],
                        ),



                      ],
                    ),
                  ),
                  Container(
                    width: 468,
                    height: 310,

                    decoration: BoxDecoration(
                      color: Color(0xffF9F6F8),
                      boxShadow: [ BoxShadow(
                        blurRadius: 2.0,
                      )],
                      borderRadius: BorderRadius.circular(20),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,bottom: 2),
                            child: Text("Name",style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                            ),),
                          ),
                          Container(
                            width: 310,
                            height: 60,
                            decoration: BoxDecoration(
                              boxShadow: [ BoxShadow(
                                blurRadius: 2.0,
                              )],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                onChanged: onchanged,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                           prefixIcon: Icon(Icons.person,color: Color(0xffFE67C4),),

                                    hintText: 'Enter your name..'),
                                controller: _nameTextController,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,top:20.0,bottom: 2),
                            child: Text("E Mail",style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Container(
                              width: 310,
                              height: 60,

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [ BoxShadow(
                                    blurRadius: 2.0,
                                  )],

                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  onChanged: onchanged,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail,color: Color(0xffFE67C4),),

                                      hintText: 'Your E-mail'),
                                  controller: _emailTextController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,top:20.0,bottom: 2),
                            child: Text("Phone",style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Container(
                              width: 310,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [ BoxShadow(
                                    blurRadius: 2.0,
                                  )],

                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  onChanged: onchanged,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.phone,color: Color(0xffFE67C4),),

                                      hintText: 'Phone No'),
                                  controller: _introTextController,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 2),
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
                        onPressed: ()  {
                                     _checkUserStatus();
                            },


                        child: Text("Lets' Chat", style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ),





                ],
              ),
            ),
          ),
          loadingCircle(_isLoading),
        ],
      ),

    );
  }
  void _checkUserStatus() async{
    setState(() => _isLoading = true);
    String alertString = checkValidUserData(_nameTextController.text, _introTextController.text);
    if (alertString.trim() != '') {
      showAlertDialog(context,alertString);
    }
    else {

      }
      _updateFBdata();
    }



  void _moveToChatList(List<String> userData) {
    setState(() => _isLoading = false);
    if(userData != null) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => recent()));
    }
    else { showAlertDialog(context,'Save user data error'); }
  }


  void _updateFBdata(){
    if(_userImageFile.path != ''){
      FBStorage.instanace.saveUserImageToFirebaseStorage(_emailTextController.text,
          _userId,_nameTextController.text,_introTextController.text,
          _userImageFile).then((userData){
        _moveToChatList(userData);
      });
    }else{
      FBCloudStore.instanace.saveUserDataToFirebaseDatabase(_emailTextController.text,_userId.toString(),_nameTextController.text,_introTextController.text,'https://firebasestorage.googleapis.com/v0/b/i-call-404eb.appspot.com/o/icons8-contacts-208.png?alt=media&token=98dedcac-75f1-4b49-a0c7-7f7f7664160b').then((userData){
        _moveToChatList(userData);
      });
    }
  }


}

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  @override
  void initState() {
    super.initState();

    //Receive text data when app is running
    _dataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String text) {
          setState(() {
            _sharedText = text;
          });
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
    });

    //Receive files when app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
      if (files != null) {
        setState(() {
          _sharedFiles = files;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dataStreamSubscription.cancel();
  }

  StreamSubscription _dataStreamSubscription;

  String _sharedText = "";

  List<SharedMediaFile> _sharedFiles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Shared Text is :",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(_sharedText, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 100),
            const Text("Shared files:",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 5,
            ),
            if (_sharedFiles != null)
              Text(_sharedFiles.map((f) => f.path).join(",") ?? "",
                  style: const TextStyle(fontSize: 20)),
            Container(
                width: 200,
                height: 200,
                child: Image.file(File(_sharedFiles.map((f) => f.path).join(",") ?? "",)))


          ],
        ),
      ),
    );
  }
}
class splashscreen extends StatefulWidget {
  const splashscreen({Key  key}) : super(key: key);

  @override
  _splashscreenState createState() => _splashscreenState();
}
class _splashscreenState extends State<splashscreen> {

  void initState() {

    super.initState();
    firsttime();
    getContact();
    userdetail();
    newuser();
    Timer(Duration(seconds: 3),

            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>   recent2(first,nameuser,Imgurl,chatno),
            )
        )
    );
  }
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
        first = 2;
      });

    }

  }
  int chatno = 1;
  newuser()  async {

    final result =  await FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).collection('chatlist').limit(1).get();
    if (result.size == 0) {
      setState(() {
        chatno = 2;

      });

    }
  }
  int first =0;
  @override
  Widget build(BuildContext context) {

    final data = MediaQuery.of(context);
    return   Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [

          Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height *0.32),
            child: Center(
              child: Container(
                width: 170,
                height:170,
                child: Image.asset("assets/icalllogo.png",fit: BoxFit.contain,),
              ),
            ),
          ),
          SizedBox(height: 5,),


          Center(child: Text("Enjoy your time",style: GoogleFonts.kaushanScript(fontSize: 25),)),
          SizedBox(height: 30,),
          CircularProgressIndicator()
        ],
        ),
      ),
    );

  }
  int i;
  var nameuser;
  var Imgurl;
  void getContact() async {

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
  }
}



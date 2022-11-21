import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/Controllers/fb_firestore.dart';
import 'package:i_call/Controllers/fb_storage.dart';
import 'package:i_call/Controllers/image_controller.dart';
import 'package:i_call/subWidgets/common_widgets.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _introTextController = TextEditingController();
  File _userImageFile = File('');
  String _userImageUrlFromFB = '';
  User _userik = FirebaseAuth.instance.currentUser;
  String name;
  String phone;
  String Imageurl;
  void onchanged(String value){
    setState(() {
      name= value;
    });
  }
   getuser() async{
     var  document = await FirebaseFirestore.instance.collection('users').doc(_userik.uid.toString()).get();
     Map<String,dynamic> value = document.data();
     setState(() {
       _nameTextController.text = value['name'].toString();
       _emailTextController.text = value['email'].toString();
      phone = value['phone'].toString();
      Imageurl= value['userImageUrl'].toString();

     });


   }
   @override
  void initState() {
    getuser();
    // TODO: implement initState
    super.initState();
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
      body: Stack(
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
                                  child: _userImageFile == null  || _userImageFile.path.isEmpty ?
                                  ImageController.instance
                                      .cachedImage(
                                      Imageurl.toString()) :
                                   Image.file( _userImageFile,
                                      fit: BoxFit.fill),

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
                                child: Row(
                                  children: [
                                    Icon(Icons.phone,color: Color(0xffFE67C4),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("+91 ${phone.toString()}"),
                                    ),
                                  ],
                                )
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
                        _showMyDialog2();
                          update();


                        },


                        child: Text("Update Profile", style: GoogleFonts.poppins(
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
          // youtubePromotion(),

        ],
      ),
    );
  }
  update(){
    FirebaseFirestore.instance.collection("users").doc(_userik.uid.toString()).update({
      'name' : _nameTextController.text,
      'phone' : phone.toString(),
      'email' : _emailTextController.text,
    });
    _updateFBdata();

  }
  void _updateFBdata(){
    if(_userImageFile.path != ''){
      FBStorage.instanace.saveUserImageToFirebaseStorage(_emailTextController.text,
          _userik.uid.toString(),_nameTextController.text,phone.toString(),
          _userImageFile).then((userData){
            _moveToChatList(userData);
          });
    }else{
      FBCloudStore.instanace.saveUserDataToFirebaseDatabase(_emailTextController.text,_userik.uid.toString().toString(),_nameTextController.text,phone.toString(),Imageurl.toString()).then((userData){

      });
    }
  }
  void _moveToChatList(List<String> userData) {

    if(userData != null) {

    }
    else { showAlertDialog(context,'Save user data error'); }
  }

  Future<void> _showMyDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Proflie Updated Successfully'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('' ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: (){

              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }, child: Text("Ok"))

          ],
        );
      },
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_call/main.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:responsive_widgets/responsive_widgets.dart';




class Loginotp extends StatefulWidget {
  final String phone;

  var name;
  Loginotp(this.phone);

  @override
  State<Loginotp> createState() => _LoginotpState();
}

class _LoginotpState extends State<Loginotp> {
  final GlobalKey<ScaffoldState>_scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinputFocusNode = FocusNode();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User _userik = FirebaseAuth.instance.currentUser;
  final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black,
      )
  );


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      child: Scaffold(

        key: _scaffoldkey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          brightness: Brightness.dark,
          title: TextResponsive("Verifying your number",
              style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              )

          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(

                  width: size.width/1.5,
                  height: size.height /3.9,
               child:   Lottie.asset("assets/OTP.json"),
                 ),

              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ContainerResponsive(

                  margin: EdgeInsets.only(top: 40),
                  child: const TextResponsive("Auto-verifying your number...", style:
                  TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                  textAlign: TextAlign.center,
                  ),
                ),

              ),
              ContainerResponsive(

                margin: EdgeInsets.only(top: 2),
                child: TextResponsive("+91 ${widget.phone}", style:
                TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Color(0xffFE67C4)),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(padding: EdgeInsets.all(30),
                  child: PinPut(

                    fieldsCount: 6,
                    textStyle: TextStyle(fontSize: 25, color: Color(0xffFE67C4)),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinputFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration.copyWith(
                      color: Colors.white,

                    ),
                    selectedFieldDecoration: pinPutDecoration.copyWith(
                        color: Colors.white,
                        boxShadow: [ BoxShadow(
                          blurRadius: 2.0,
                        )],
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(.5),
                      ),
                    ),
                    followingFieldDecoration: pinPutDecoration.copyWith(
                        color: Colors.white,
                        boxShadow: [ BoxShadow(
                          blurRadius: 2.0,
                        )],
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(.5),
                      ),),
                    pinAnimationType: PinAnimationType.fade,
                    cursorColor: Color(0xffF84F9D),

                    onSubmit: (pin) async{
                      try{
                        await FirebaseAuth.instance.signInWithCredential(
                          PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin),

                        )
                            .then((value) async {
                          value.user?.updateProfile(displayName: widget.name);
                          if(value.user!=null){
                            uploaddata();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(widget.phone)), (route) => false);
                            Fluttertoast.showToast(
                              msg: "LOGIN SUCCESSFULLY",);
                          }
                        }


                        );

                      } catch (e) {
                        TextResponsive('invalid otp');
                      }
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: TextResponsive("Click to change your phone number",style: TextStyle(
                  color: Colors.indigo
                ),)),
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
                    onPressed: () async {
                      verificationCompleted: (PhoneAuthCredential credential)async {
                      await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                        if (value.user != null) {
                          uploaddata();
                          value.user?.updateProfile(displayName: widget.name);
                          Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage(widget.phone)), (
                                route) => false,);
                          Fluttertoast.showToast(
                            msg: "LOGIN SUCCESSFULLY",);
                        }
                      }
                      );};
                    },
                    child: Text("Verify", style: GoogleFonts.poppins(
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
    );
  }
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: '+91 ${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential)async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) async{
          if(value.user != null){
            uploaddata();
            value.user?.updateProfile(displayName: widget.name);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(widget.phone)), (route) => false,);
            Fluttertoast.showToast(
              msg: "LOGIN SUCCESSFULLY"  ,);
          }
        });
      }, verificationFailed: (FirebaseAuthException e){
        print(e.message);
      }, codeSent: (String VerificationId, int resendToken){
        setState(() {
          _verificationCode = VerificationId;
        });
      }, codeAutoRetrievalTimeout: (String VerificationID){
        setState(() {
          _verificationCode = VerificationID;
        });
      },
      timeout: Duration(seconds: 60),);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
  Future uploaddata() async {
    await _firestore
        .collection('usersdetails')
        .doc(_userik.uid)
        .set({
      "userID" : _userik.uid.toString()

    }
    );

  }
}



import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'full_photo.dart';

Widget loadingCircle(bool value,){
  return Positioned(
    child: value ? Container(
      child: Center(
        child:  Container(
            width: 200,
            height: 200,
            child: Lottie.asset("assets/Loading2.json")),),
      color: Colors.white.withOpacity(0.7),
    ) : Container(),
  );
}

Widget loadingCircleForFB(){
  return Container(
 width: 200,
      height: 200,
      child: Lottie.asset("assets/Loading2.json"),
  color: Colors.white.withOpacity(0.7),
  );
}

Widget imageMessage(context,imageUrlFromFB,username) {
  return Container(
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
      padding: const EdgeInsets.all(4.0),
      child: Container(
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
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FullPhoto(url: imageUrlFromFB,selectedUserName: username,)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: imageUrlFromFB,
              placeholder: (context, url) => Container(
                transform: Matrix4.translationValues(0, 0, 0),
                child: Container(
                  width: 200,
                  height: 200,
                  child: Lottie.asset("assets/Loading2.json"),
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              width: 60,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  );
}

void showAlertDialog(context,String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(msg),
      );
    });
}
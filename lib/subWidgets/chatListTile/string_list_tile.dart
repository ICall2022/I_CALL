


import 'package:flutter/material.dart';

import '../../Model/const.dart';
import '../../chatroom.dart';

Widget stringListTile(String data){
  Widget _returnWidget;
  if(data == chatInstruction){
    _returnWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("")
    );
  }else{
    _returnWidget = Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xffF8E6EE)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12,6,12,6),
            child: Text(data,style: TextStyle(color: Colors.black87,fontSize: 12),),
          ),
        ),
      ),
    );
  }

  return _returnWidget;
}



import 'package:flutter/material.dart';

import '../../Model/const.dart';


Widget stringListTile(String data){
  Widget _returnWidget;
  if(data == chatInstruction){
    _returnWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:const BoxDecoration(
            color:Color(0xffF8E6EE),
            borderRadius: BorderRadius.all(
                Radius.circular(25.0)
            )
        ),
        child:const Padding(
          padding:  EdgeInsets.all(16.0),
          child: Text("""Hello Welcome to join with  
I call App team. 

This app's unique feature is "auto delete" feature. All your messages and media files will be deleted automatically within 2 days. You will feel good once you see your emptied space in your mobile phone. If you want to save there is save button which has to be touched by you and the same will be saved. Enjoy your time which is precious!"""
            ,textAlign: TextAlign.center,),
        ),
      ),
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
import 'package:flutter/material.dart';

import 'package:i_call/Controllers/image_controller.dart';

class ViewProfile extends StatelessWidget {
  String name;
  String phone;
  String imagurl;
  ViewProfile(this.imagurl,this.name,this.phone, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Container(
            width: 400,
            height: 360,
            child:ImageController.instance
                .cachedImage(imagurl.toString()) ,
          ),
          Padding(
            padding:EdgeInsets.only(top: 320),
            child: Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
                  color: Colors.white.withOpacity(0.92)
              ),
            ),
          ),
          Padding(
            padding:EdgeInsets.only(top: 270,left: 30),
            child: Container(
              child:ClipRRect(


                    borderRadius: BorderRadius.circular(10),
                  child: ImageController.instance.cachedImage(imagurl.toString())) ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

              ),
              width: 70,
              height: 70,

            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child:const Padding(
              padding:EdgeInsets.only(top:35 ,left: 20),
              child: Icon(Icons.arrow_back_ios_new_rounded,size: 25,color: Colors.white,),
            ),
          ),
          const Padding(
            padding:EdgeInsets.only(top:35 ,left: 80),
            child: Text('Profile',style: TextStyle(
                fontWeight: FontWeight.bold,fontSize:20,color: Colors.white
            ),),
          ),
          const    Padding(
            padding:EdgeInsets.only(top: 360,left: 40),
            child: Icon(Icons.person,size: 30,color: Colors.pink,),
          ),
          Padding(
            padding:const EdgeInsets.only(top: 362,left: 85),
            child: Text(name,style: const TextStyle(
                fontWeight: FontWeight.bold,fontSize:17
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400,left: 40),
            child: Container(
              width: 300,
              child: const Divider(
                thickness: 2,

              ),
            ),
          ),
          const    Padding(
            padding:EdgeInsets.only(top: 440,left: 40),
            child: Icon(Icons.phone,size: 30,color: Colors.pink,),
          ),
          Padding(
            padding:const EdgeInsets.only(top: 443,left: 85),
            child: Text("+91 $phone ",style: const TextStyle(
                fontWeight: FontWeight.bold,fontSize:17
            ),),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 480,left: 40),
            child:  SizedBox(
              width: 300,
              child: Divider(
                thickness: 2,

              ),
            ),
          ),
          const  Padding(
            padding:EdgeInsets.only(top: 520,left: 40),
            child: Icon(Icons.access_time_rounded,size: 30,color: Colors.pink,),
          ),
          const    Padding(
            padding:EdgeInsets.only(top: 520,left: 85),
            child: Text('Auto-delete',style: TextStyle(fontWeight: FontWeight.bold,fontSize:17
            ),),
          ),
          const   Padding(
            padding:EdgeInsets.only(top: 540,left: 85),
            child: Text('Message automatically deleted',style: TextStyle(
                fontWeight: FontWeight.bold,fontSize:9
            ),),
          ),


        ],
      ),
    );
  }
}

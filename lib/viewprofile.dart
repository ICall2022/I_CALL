import 'package:flutter/material.dart';

import 'package:i_call/Controllers/image_controller.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class ViewProfile extends StatelessWidget {
  String name;
  String phone;
  String imagurl;
  ViewProfile(this.imagurl,this.name,this.phone, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

        body: Stack(
          children: [
            ContainerResponsive(
              width: 400,
              height: 360,
              child:ImageController.instance
                  .cachedImage(imagurl.toString()) ,
            ),
            Padding(
              padding:EdgeInsetsResponsive.only(top: 320),
              child: ContainerResponsive(
                width: 400,
                height: 600,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
                    color: Colors.white.withOpacity(0.92)
                ),
              ),
            ),
            Padding(
              padding:EdgeInsetsResponsive.only(top: 270,left: 30),
              child: ContainerResponsive(
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
              child: Padding(
                padding:EdgeInsetsResponsive.only(top:35 ,left: 20),
                child: Icon(Icons.arrow_back_ios_new_rounded,size: 25,color: Colors.white,),
              ),
            ),
             Padding(
              padding:EdgeInsetsResponsive.only(top:35 ,left: 80),
              child: TextResponsive('Profile',style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize:20,color: Colors.white
              ),),
            ),
                Padding(
              padding:EdgeInsetsResponsive.only(top: 360,left: 40),
              child: Icon(Icons.person,size: 30,color: Colors.pink,),
            ),
            Padding(
              padding: EdgeInsetsResponsive.only(top: 362,left: 85),
              child: TextResponsive(name,style: const TextStyle(
                  fontWeight: FontWeight.bold,fontSize:17
              ),),
            ),
            Padding(
              padding:  EdgeInsetsResponsive.only(top: 400,left: 40),
              child: ContainerResponsive(
                width: 300,
                child: const Divider(
                  thickness: 2,
                ),
              ),
            ),
                Padding(
              padding:EdgeInsetsResponsive.only(top: 440,left: 40),
              child: Icon(Icons.phone,size: 30,color: Colors.pink,),
            ),
            Padding(
              padding: EdgeInsetsResponsive.only(top: 443,left: 85),
              child: TextResponsive("+91 $phone ",style: const TextStyle(
                  fontWeight: FontWeight.bold,fontSize:17
              ),),
            ),
             Padding(
              padding: EdgeInsetsResponsive.only(top: 480,left: 40),
              child:  SizedBox(
                width: 300,
                child: Divider(
                  thickness: 2,

                ),
              ),
            ),
              Padding(
              padding:EdgeInsetsResponsive.only(top: 520,left: 40),
              child: Icon(Icons.access_time_rounded,size: 30,color: Colors.pink,),
            ),
                Padding(
              padding:EdgeInsetsResponsive.only(top: 520,left: 85),
              child: TextResponsive('Auto-delete',style: TextStyle(fontWeight: FontWeight.bold,fontSize:17
              ),),
            ),
               Padding(
              padding:EdgeInsetsResponsive.only(top: 540,left: 85),
              child: TextResponsive('Message automatically deleted',style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize:9
              ),),
            ),


          ],
        ),
      ),
    );
  }
}

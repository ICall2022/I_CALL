import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_call/Controllers/image_controller.dart';
import 'package:i_call/Controllers/utils.dart';

import 'chatroom.dart';

class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";
  User _userik = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Color(0xff800000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0)
            ),

            child: TextField(

              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, ), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
            .collection('users')
            .where("name", isEqualTo: name)
            .snapshots()
            : FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator(color: Color(0xff800000),))
              : ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ImageController.instance.cachedImage(data['userImageUrl']),
                    ),
                  ),
                  title: Text(data['name']),


                  onTap: () => _moveTochatRoom(data['FCMToken'],data['userId'],data['name'],data['userImageUrl'],data['phone']),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail,phonenumber) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(_userik.uid.toString()).get();
    Map<String, dynamic> data = docSnapshot.data();
    var name = data['name'];
    var Imgurl = data['userImageUrl'];
    try {
      String chatID = makeChatId(_userik.uid.toString(), selectedUserID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatRoom(
                      _userik.uid.toString(),
                      name.toString(),
                      Imgurl.toString(),
                      selectedUserToken,
                      selectedUserID,
                      chatID,
                      selectedUserName,
                      selectedUserThumbnail,
                    phonenumber
                  )));
    } catch (e) {
      print(e.message);
    }
  }

}
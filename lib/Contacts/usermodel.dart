import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel userModel) => json.encode(userModel.toJson());

class UserModel {
   String uId, name, image, number, status, typing, online;

  UserModel({
     this.uId,
     this.name,
     this.image,
     this.number,
     this.status,
     this.typing,
     this.online,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uId: json["uId"],
      name: json["name"],
      image: json["image"],
      number: json["number"],
      status: json["status"],
      typing: json["typing"],
      online: json["online"]);

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "name": name,
    "image": image,
    "number": number,
    "status": status,
    "typing": typing,
    "online": online,
  };
}
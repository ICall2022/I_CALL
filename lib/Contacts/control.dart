
import 'package:get/get.dart' ;
import 'package:i_call/Contacts/usermodel.dart';
class ChatController extends GetxController {
  final RxList < UserModel > _contactList = RxList ( ) ;
  RxBool isLoading= RxBool(false);

List < UserModel > get contacts => _contactList;
}
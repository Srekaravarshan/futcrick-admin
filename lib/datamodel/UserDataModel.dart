import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String displayName;
  final String uid;
  final String email;
  final String photoURL;

  UserDataModel(this.displayName, this.uid, this.email, this.photoURL);

  factory UserDataModel.fromDocument(DocumentSnapshot doc) {
    return UserDataModel(
        doc['displayName'], doc['uid'], doc['email'], doc['photoURL']);
  }
}

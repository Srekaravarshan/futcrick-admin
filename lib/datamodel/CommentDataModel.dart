import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDataModel {
  final String name;
  final String message;
  final Timestamp timeStamp;
  final String postId;
  final String userId;

  CommentDataModel(
      this.name, this.message, this.timeStamp, this.postId, this.userId);

  factory CommentDataModel.fromDocument(DocumentSnapshot doc) {
    return CommentDataModel(doc['name'], doc['message'], doc['timeStamp'],
        doc['postId'], doc['userId']);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/datamodel/CommentDataModel.dart';
import 'package:futcrick_admin/datamodel/UserDataModel.dart';
import 'package:futcrick_admin/main.dart';

class PostComments extends StatefulWidget {
  final User user;
  final String postId;

  const PostComments({Key key, this.user, this.postId}) : super(key: key);

  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  TextEditingController _commentController = TextEditingController();
  bool _isSending = false;

  // getComments() async {
  //   commentList.clear();
  //   QuerySnapshot docCollection = await commentsRef
  //       .doc(widget.postId)
  //       .collection('postComments')
  //       .orderBy('timeStamp')
  //       .get();
  //   for (QueryDocumentSnapshot doc in docCollection.docs) {
  //     commentList.add(CommentDataModel.fromDocument(doc));
  //   }
  // }

  DocumentReference postRefDocRef;

  Future<String> getUserProfileImage(String uid) async {
    DocumentSnapshot userDocSnapshot = await usersRef.doc(uid).get();
    UserDataModel user = UserDataModel.fromDocument(userDocSnapshot);
    return user.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: commentsRef
                .doc(widget.postId)
                .collection('postComments')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(child: circularProgressIndicator().center());
              }
              List<CommentDataModel> commentList = [];
              print(snapshot.data.docs);
              snapshot.data.docs.forEach((doc) {
                commentList.add(CommentDataModel.fromDocument(doc));
              });
              // for (QueryDocumentSnapshot doc in snapshot.data.docs) {
              //   commentList.add(CommentDataModel.fromDocument(doc));
              // }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: commentList.length,
                        itemBuilder: (context, index) {
                          //TODO: time ago
                          return FutureBuilder<String>(
                            future: getUserProfileImage(
                                commentList.elementAt(index).userId),
                            builder: (context, snapshot) {
                              return myListTile(
                                context,
                                title: commentList.elementAt(index).name,
                                subtitle: commentList.elementAt(index).message,
                                leading: CircleAvatar(
                                    backgroundColor: secondaryColor,
                                    backgroundImage: snapshot.data != null
                                        ? NetworkImage(snapshot.data)
                                        : null),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                          child: Container(
                        height: 70,
                        child: TextField(
                          maxLength: null,
                          maxLines: null,
                          controller: _commentController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            isDense: true,
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: secondaryColor.withOpacity(0.2),
                            hintText: 'Comment',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                        ).padding(left: 10, right: 10, top: 10, bottom: 10),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: _isSending
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: circularProgressIndicator())
                            : IconButton(
                                icon: Icon(
                                  Icons.send_rounded,
                                  color: secondaryColor,
                                ),
                                onPressed: () async {
                                  print(DateTime.now().toString());
                                  if (_commentController.text.trim() != '') {
                                    setState(() {
                                      _isSending = true;
                                    });
                                    postRefDocRef = postRef.doc(widget.postId);
                                    DocumentSnapshot postRefDocSnapShot =
                                        await postRefDocRef.get();
                                    // Post post = Post.fromDocument(postRefDocSnapShot);
                                    // int commentCount =
                                    //     postRefDocSnapShot.get('commentCount');
                                    CollectionReference collectionRef =
                                        commentsRef
                                            .doc(widget.postId)
                                            .collection('postComments');
                                    QuerySnapshot collection =
                                        await collectionRef.get();
                                    DocumentReference documentRef =
                                        collectionRef.doc();
                                    documentRef.set({
                                      'timeStamp': FieldValue.serverTimestamp(),
                                      'postId': widget.postId,
                                      'name': widget.user.displayName != null
                                          ? widget.user.displayName
                                          : 'Anonymous',
                                      'message': _commentController.text.trim(),
                                      'userId': widget.user.uid
                                    });
                                    postRefDocRef.update({
                                      'commentCount': collection.docs.length + 1
                                    });
                                    setState(() {
                                      _commentController.clear();
                                      _isSending = false;
                                    });
                                  }
                                },
                              ),
                      )
                    ],
                  ),
                ],
              );
            }));
  }

  myListTile(BuildContext context,
      {String title, String subtitle, Widget leading}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 45, width: 45, child: leading),
          SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontFamily: 'Ubuntu', fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontFamily: 'FiraSans'),
                ),
              ],
            ),
          )
        ],
      ).padding(top: 10, left: 20, right: 20, bottom: 10),
    );
  }
}

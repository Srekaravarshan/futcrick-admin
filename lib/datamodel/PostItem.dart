import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/main.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'file:///C:/Users/HP/AndroidStudioProjects/futcrick_admin/lib/Pages/home/PostComments.dart';
import 'file:///C:/Users/HP/AndroidStudioProjects/futcrick_admin/lib/Pages/home/VideoScreen.dart';

import 'Post.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final File file;
  final User user;
  const PostItem(this.user, {Key key, this.post, this.file}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked = false;

  Row footerSection(int likeCount, int commentCount, User user, Map commentList,
      String postId, bool isImage, String imageUrl) {
    return Row(
      children: [
        IconButton(
            icon:
                Icon(isLiked ? Icons.favorite : Icons.favorite_border_rounded),
            splashColor: secondaryColor,
            color: iconColor,
            onPressed: () {
              setState(() {
                isLiked = true;
              });

              like();
            }),
        Text(
          likeCount.toString(),
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.message, color: blueColor),
          splashColor: secondaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostComments(
                    postId: postId,
                    user: user,
                  ),
                ));
          },
        ),
        Text(commentCount.toString(), style: TextStyle(color: Colors.black54)),
        // IconButton(
        //     icon: Icon(Icons.delete),
        //     color: Colors.red,
        //     onPressed: () async {
        //       showDialog(
        //         context: context,
        //         builder: (context) => CupertinoAlertDialog(
        //           title: Text('Confirm delete'),
        //           actions: [
        //             FlatButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: Text('Cancel')),
        //             FlatButton(
        //                 onPressed: () async {
        //                   await postRef.doc(postId).delete();
        //                   await commentsRef
        //                       .doc(postId)
        //                       .get()
        //                       .then((value) async {
        //                     if (value.exists) {
        //                       await commentsRef.doc(postId).delete();
        //                     }
        //                     return;
        //                   });
        //                   if (isImage) {
        //                     String filePath = imageUrl
        //                         .replaceAll(
        //                             new RegExp(
        //                                 r'https://firebasestorage.googleapis.com/v0/b/futcrick-f5735.appspot.com/o/'),
        //                             '')
        //                         .split('?')[0];
        //                     await FirebaseStorage.instance
        //                         .ref()
        //                         .child(filePath)
        //                         .delete();
        //                     Navigator.pop(context);
        //                   }
        //                 },
        //                 child: Text('Delete')),
        //           ],
        //         ),
        //       );
        //     })
      ],
    );
  }

  like() async {
    DocumentReference postDoc = postRef.doc(widget.post.postId);
    DocumentSnapshot docGet = await postDoc.get();
    int likes = docGet.get('likes');
    await postDoc.update({'likes': likes + 1});
    await postDoc.update({
      'isLiked': {widget.user.uid: true}
    });
    // await likedRef
    //     .doc(widget.user.uid)
    //     .collection('likedPosts')
    //     .doc(widget.post.postId)
    //     .set({'postId': widget.post.postId});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showPostDetails(widget.post);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                            color: yellowColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            image: widget.file != null
                                ? DecorationImage(
                                    image: FileImage(widget.file),
                                    fit: BoxFit.cover)
                                : DecorationImage(
                                    image: widget.post.isImage
                                        ? NetworkImage(widget.post.url)
                                        : NetworkImage(
                                            'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(widget.post.url)}/0.jpg'),
                                    fit: BoxFit.cover)),
                      ),
                      widget.post.isImage
                          ? Container()
                          : Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 50,
                                    width: 75,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFF0000),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Icon(Icons.play_arrow,
                                        color: Colors.white, size: 42),
                                  ))),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                //title
                widget.post.isImage
                    ? Text(
                        widget.post.title,
                        style: TextStyle(
                            color: backgroundColor,
                            fontFamily: 'Ubuntu',
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : FutureBuilder<String>(
                        future: getInfo(widget.post.url),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return Text(
                            snapshot.data,
                            style: TextStyle(
                                color: backgroundColor,
                                fontFamily: 'Ubuntu',
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                SizedBox(height: 5),

                // preview content
                Text(
                  (widget.post.previewContent == '' ||
                          widget.post.previewContent == null)
                      ? widget.post.content
                      : widget.post.previewContent,
                  style: TextStyle(
                      color: backgroundColor,
                      fontFamily: 'FiraSans',
                      fontSize: 16),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // read more
                GestureDetector(
                  onTap: () {
                    showPostDetails(widget.post);
                  },
                  child: Text(
                    'Read more...',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            // image

            // like comment button
            StreamBuilder<DocumentSnapshot>(
              stream: postRef.doc(widget.post.postId).snapshots(),
              builder: (context, snapshot) {
                int likeCount;
                int commentCount;
                Map commentList;
                if (!snapshot.hasData) {
                  likeCount = 0;
                  commentCount = 0;
                  commentList = {};
                  return footerSection(
                      likeCount,
                      commentCount,
                      widget.user,
                      commentList,
                      widget.post.postId,
                      widget.post.isImage,
                      widget.post.url);
                }
                Post post = Post.fromDocument(snapshot.data);
                Map likedMap = post.isLiked;
                isLiked = likedMap.containsKey(widget.user.uid);
                likeCount = post.likes;
                commentCount = post.commentCount;
                // commentList = post.comments;
                return footerSection(
                    likeCount,
                    commentCount,
                    widget.user,
                    commentList,
                    post.postId,
                    widget.post.isImage,
                    widget.post.url);
              },
            )
          ],
        ));
  }

  Future<String> getInfo(String url) async {
    http.Response content =
        await http.get('https://www.youtube.com/oembed?url=$url&format=json');
    print(content.statusCode);
    try {
      if (content.statusCode == 200) {
        return json.decode(content.body)['title'];
      } else {
        return 'Unavailable...';
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());
      return 'Something goes wrong...';
    }
  }

  showPostDetails(Post post) async {
    String youtubeTitle = post.isImage ? '' : await getInfo(post.url);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(44.0)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
              decoration: BoxDecoration(
                color: sheetColor,
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: widget.post.isImage
                        ? () {}
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoScreen(
                                        id: YoutubePlayer.convertUrlToId(
                                            post.url))));
                          },
                    child: Stack(
                      children: [
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(44),
                                topLeft: Radius.circular(44)),
                            image: DecorationImage(
                                image: NetworkImage(post.isImage
                                    ? post.url
                                    : 'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(widget.post.url)}/0.jpg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        widget.post.isImage
                            ? Container()
                            : Positioned.fill(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 50,
                                      width: 75,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFF0000),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Icon(Icons.play_arrow,
                                          color: Colors.white, size: 42),
                                    ))),
                      ],
                    ),
                  ),
                  Text(
                    post.isImage ? post.title : youtubeTitle,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Ubuntu',
                        height: 1.2,
                        fontWeight: FontWeight.w700),
                  ).padding(top: 25, left: 25, right: 25, bottom: 25),
                  Text(
                    post.content,
                    style: TextStyle(
                        fontFamily: 'FiraSans', fontSize: 16, height: 2.2),
                  ).padding(right: 25, left: 25, bottom: 50)
                ],
              )),
            ));
  }
}

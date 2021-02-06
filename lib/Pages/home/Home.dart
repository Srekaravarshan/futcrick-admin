import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/datamodel/MatchCard.dart';
import 'package:futcrick_admin/datamodel/MatchDataModel.dart';
import 'package:futcrick_admin/datamodel/Post.dart';
import 'package:futcrick_admin/datamodel/PostItem.dart';
import 'package:futcrick_admin/main.dart';

import '../../Constants.dart';
import 'NewPost.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  const MyHomePage({Key key, this.user}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin<MyHomePage> {
  List<MatchCard> liveMatches = [];
  List<PostItem> postItems = [];
  List<DocumentSnapshot> documents = [];
  ScrollController _scrollController;
  bool isMore = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    fetchPosts(widget.user);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        fetchPosts(widget.user);
      }
    }
  }

  Future<void> fetchPosts(User user) async {
    if (isMore) {
      QuerySnapshot snapshot;
      if (postItems.length == 0) {
        snapshot = await postRef
            .limit(10)
            .orderBy('timeStamp', descending: true)
            .get();
        for (QueryDocumentSnapshot document in snapshot.docs) {
          documents.add(document);
          postItems.add(PostItem(user, post: Post.fromDocument(document)));
        }
      } else {
        try {
          snapshot = await postRef
              .limit(10)
              .orderBy('timeStamp', descending: true)
              .startAfterDocument(documents[documents.length - 1])
              .get()
              .then((value) {
            for (QueryDocumentSnapshot document in value.docs) {
              documents.add(document);
              postItems.add(PostItem(
                widget.user,
                post: Post.fromDocument(document),
              ));
            }
            return;
          });
        } catch (e) {
          print('error in fetch data in else block and more is $isMore');
          print(e.toString());
        }
      }
      if (snapshot.docs.length < 10) {
        setState(() {
          isMore = false;
        });
      }
    }
  }

  Future<void> refresh() async {
    setState(() {
      isMore = true;
      postItems.clear();
    });
    await fetchPosts(widget.user);
  }

  Widget headingText(String text) {
    return Text(
      text,
      style:
          TextStyle(fontSize: 20, fontFamily: 'Ubuntu', color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'home',
        backgroundColor: secondaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewPost(user: widget.user)));
        },
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  color: backgroundColor.withOpacity(0.5),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Ubuntu'),
                        children: [
                          TextSpan(text: 'Fut'),
                          TextSpan(
                              text: 'crick.',
                              style: TextStyle(color: secondaryColor))
                        ]),
                  ).center(),
                ),
                StreamBuilder(
                  stream: matchesRef.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: circularProgressIndicator());
                    }
                    liveMatches.clear();
                    snapshot.data.docs.forEach((doc) {
                      MatchDataModel matchData =
                          MatchDataModel.fromDocument(doc);
                      switch (matchData.stateOfMatch) {
                        case 'Live':
                          liveMatches.add(
                              MatchCard(matchData: matchData, isLive: true));
                          break;
                      }
                    });
                    return liveMatches.length != 0
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Live matches',
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu', fontSize: 22)),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: ListView.separated(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(width: 20),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            liveMatches.elementAt(index),
                                        itemCount: liveMatches.length,
                                      ),
                                    )),
                              ),
                            ],
                          )
                        : Container();
                  },
                ),
                SizedBox(height: 50),
                Text('Latest news',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22)),
                SizedBox(height: 20),
                postItems.length == 0 ? Text('There is no news.') : Container(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postItems.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      Stack(
                        children: [
                          postItems[index],
                          Positioned(
                            bottom: 5,
                            right: 30,
                            child: IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text('Confirm delete'),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel')),
                                        FlatButton(
                                            onPressed: () async {
                                              await postRef
                                                  .doc(postItems[index]
                                                      .post
                                                      .postId)
                                                  .delete();
                                              await commentsRef
                                                  .doc(postItems[index]
                                                      .post
                                                      .postId)
                                                  .get()
                                                  .then((value) async {
                                                if (value.exists) {
                                                  await commentsRef
                                                      .doc(postItems[index]
                                                          .post
                                                          .postId)
                                                      .delete();
                                                }
                                                return;
                                              });
                                              if (postItems[index]
                                                  .post
                                                  .isImage) {
                                                String filePath = postItems[
                                                        index]
                                                    .post
                                                    .url
                                                    .replaceAll(
                                                        new RegExp(
                                                            r'https://firebasestorage.googleapis.com/v0/b/futcrick-f5735.appspot.com/o/'),
                                                        '')
                                                    .split('?')[0];
                                                await FirebaseStorage.instance
                                                    .ref()
                                                    .child(filePath)
                                                    .delete();
                                                Navigator.pop(context);
                                                await refresh();
                                              }
                                            },
                                            child: Text('Delete')),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ]);
                  },
                ),
                SizedBox(height: 20),
                Text(isMore ? 'Loading...' : 'End of page.').center(),
                SizedBox(height: isMore ? 10 : 50),
              ],
            )),
      ),
    );
  }
}

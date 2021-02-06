import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/datamodel/Post.dart';
import 'package:futcrick_admin/datamodel/PostItem.dart';
import 'package:futcrick_admin/main.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'VideoScreen.dart';

class NewPost extends StatefulWidget {
  final User user;

  const NewPost({Key key, this.user}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  bool _isUploading = false;
  String postId = Uuid().v4();

  TextEditingController _postTitle = TextEditingController();
  TextEditingController _previewContent = TextEditingController();
  TextEditingController _url = TextEditingController();
  TextEditingController _content = TextEditingController();

  bool _isImage = true;

  File file;

  String _previewVideoError = '';

  String contentErrorMessage = '';
  String _titleErrorMessage = '';

  Future<String> uploadImage(File imageFile) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child("post_$postId.jpg");
    Task uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  createPostInFirestore(String url, String title, String previewContent,
      String content, String postId) {
    postRef.doc(postId).set({
      'url': url,
      'title': title,
      'previewContent': previewContent,
      'content': content,
      'likes': 0,
      'isLiked': Map<String, dynamic>(),
      'commentCount': 0,
      'isImage': _isImage,
      'timeStamp': timeStamp,
      'postId': postId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // logo
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      color: secondaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Container(
                    width: MediaQuery.of(context).size.width - 156,
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
                ],
              ),

              // title
              Text(
                'Create new post',
                style: TextStyle(fontSize: 18),
              ).center(),
              SizedBox(height: 20),

              // image
              Row(
                children: [
                  Radio(
                      value: false,
                      groupValue: _isImage,
                      onChanged: (value) {
                        setState(() {
                          _isImage = value;
                        });
                      }),
                  Text('Youtube video')
                ],
              ),

              // radio button
              Row(
                children: [
                  Radio(
                      value: true,
                      groupValue: _isImage,
                      onChanged: (value) {
                        setState(() {
                          _isImage = value;
                        });
                      }),
                  Text('Image')
                ],
              ),
              SizedBox(height: 10),

              // image picker and youtube text field
              _isImage
                  ? Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white)),
                            height: 200,
                            width: double.infinity,
                            child: file != null
                                ? Image.file(file)
                                : GestureDetector(
                                    onTap: () async {
                                      // ignore: deprecated_member_use
                                      File file = await ImagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      setState(() {
                                        this.file = file;
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))
                                          // border: Border.all(color: secondaryColor, width: 1)
                                          ),
                                      child: Text('Upload image').center(),
                                    )).center()),
                        file != null ? SizedBox(height: 10) : Container(),
                        file != null
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    this.file = null;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))
                                      // border: Border.all(color: secondaryColor, width: 1)
                                      ),
                                  child: Text('Clear image').center(),
                                ),
                              )
                            : Container()
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _previewVideoError != null && _previewVideoError != ''
                            ? Text(
                                _previewVideoError,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        _previewVideoError != null && _previewVideoError != ''
                            ? SizedBox(height: 5)
                            : Container(),
                        TextField(
                          controller: _url,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Youtube video URL',
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (_url.text.trim() != '') {
                              if (YoutubePlayer.convertUrlToId(
                                      _url.text.trim()) !=
                                  null) {
                                setState(() {
                                  _previewVideoError = '';
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                          id: YoutubePlayer.convertUrlToId(
                                              _url.text.trim())),
                                    ));
                              } else {
                                setState(() {
                                  _previewVideoError = 'Invalid url';
                                });
                              }
                            } else {
                              setState(() {
                                _previewVideoError = 'Enter url';
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: Text('Preview video').center(),
                          ),
                        )
                      ],
                    ),

              SizedBox(height: 30),
              _titleErrorMessage != null && _titleErrorMessage != ''
                  ? Text(
                      _titleErrorMessage,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              _titleErrorMessage != null && _titleErrorMessage != ''
                  ? SizedBox(height: 5)
                  : Container(),
              _isImage
                  ? TextField(
                      controller: _postTitle,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Post title',
                      ),
                      maxLines: null,
                    )
                  : Container(),
              SizedBox(height: 10),

              TextField(
                controller: _previewContent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Preview content (optional)',
                ),
                maxLines: null,
                minLines: 3,
              ),
              SizedBox(height: 10),
              contentErrorMessage != null && contentErrorMessage != ''
                  ? Text(
                      contentErrorMessage,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              contentErrorMessage != null && contentErrorMessage != ''
                  ? SizedBox(height: 5)
                  : Container(),

              TextField(
                controller: _content,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Content',
                ),
                maxLines: null,
                minLines: 5,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if (_content.text.trim() != '') {
                        if (_isImage &&
                            file != null &&
                            _postTitle.text.trim() != '') {
                          setState(() {
                            contentErrorMessage = '';
                            _titleErrorMessage = '';
                          });
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 30),
                                  PostItem(
                                    widget.user,
                                    post: Post(
                                        _postTitle.text.trim(),
                                        _previewContent.text.trim(),
                                        _content.text.trim(),
                                        _url.text.trim(),
                                        0,
                                        0,
                                        Map(),
                                        _isImage,
                                        Timestamp.now(),
                                        postId),
                                    file: file,
                                  ),
                                  SizedBox(height: 30)
                                ],
                              );
                            },
                          );
                        } else if (!_isImage && _url.text.trim() != '') {
                          if (YoutubePlayer.convertUrlToId(_url.text.trim()) !=
                              null) {
                            setState(() {
                              contentErrorMessage = '';
                              _titleErrorMessage = '';
                            });
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 30),
                                    PostItem(
                                      widget.user,
                                      post: Post(
                                          _postTitle.text.trim(),
                                          _previewContent.text.trim(),
                                          _content.text.trim(),
                                          _url.text.trim(),
                                          0,
                                          0,
                                          Map(),
                                          _isImage,
                                          Timestamp.now(),
                                          postId),
                                    ),
                                    SizedBox(height: 30)
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              _previewVideoError = 'Invalid url';
                            });
                          }
                        } else {
                          setState(() {
                            _titleErrorMessage = 'Title should not be null';
                          });
                        }
                      } else {
                        setState(() {
                          contentErrorMessage = 'Content cannot be null';
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: secondaryColor, width: 1)),
                      child: Text('Preview').center(),
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (_content.text.trim() != '') {
                          if (_isImage && _postTitle.text.trim() != '') {
                            // matchesRef.doc()

                            setState(() {
                              contentErrorMessage = '';
                              _isUploading = true;
                            });
                            if (_isImage) {
                              await compressImage();
                            }
                            String url = _isImage
                                ? await uploadImage(file)
                                : _url.text.trim();
                            createPostInFirestore(
                              url,
                              _postTitle.text.trim(),
                              _previewContent.text.trim(),
                              _content.text.trim(),
                              postId,
                            );
                            _postTitle.clear();
                            _previewContent.clear();
                            _content.clear();
                            setState(() {
                              file = null;
                              _isUploading = false;
                              postId = Uuid().v4();
                            });
                            print('uploaded');
                          } else if (!_isImage && _url.text.trim() != '') {
                            if (YoutubePlayer.convertUrlToId(
                                    _url.text.trim()) !=
                                null) {
                              setState(() {
                                _isUploading = true;
                              });
                              String url = _url.text.trim();
                              createPostInFirestore(
                                  url,
                                  _postTitle.text.trim(),
                                  _previewContent.text.trim(),
                                  _content.text.trim(),
                                  postId);
                              _previewContent.clear();
                              _content.clear();
                              setState(() {
                                _isUploading = false;
                                postId = Uuid().v4();
                              });
                              print('uploaded');
                            } else {
                              _previewVideoError = 'Invalid url';
                            }
                          } else {
                            setState(() {
                              _previewVideoError = 'Enter url';
                            });
                          }
                        } else {
                          setState(() {
                            contentErrorMessage = 'Content cannot be null';
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text('Upload').center(),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 50)
            ],
          ).padding(left: 30, right: 30),
        ),
      ),
    );
  }
}

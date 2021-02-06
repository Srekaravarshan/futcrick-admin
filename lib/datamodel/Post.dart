import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String _title;
  String _previewContent;
  String _content;
  String _url;
  int _likes;
  int _commentCount;
  Map _isLiked;
  bool _isImage;
  Timestamp _timeStamp;
  String postId;

  Post(
      this._title,
      this._previewContent,
      this._content,
      this._url,
      this._likes,
      this._commentCount,
      this._isLiked,
      this._isImage,
      this._timeStamp,
      this.postId);

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
        doc['title'],
        doc['previewContent'],
        doc['content'],
        doc['url'],
        doc['likes'],
        doc['commentCount'],
        doc['isLiked'],
        doc['isImage'],
        doc['timeStamp'],
        doc['postId']);
  }

  Map get isLiked => _isLiked;
  bool get isImage => _isImage;
  int get likes => _likes;
  int get commentCount => _commentCount;
  String get url => _url;
  String get content => _content;
  String get previewContent => _previewContent;
  String get title => _title;
  Timestamp get timestamp => _timeStamp;
}

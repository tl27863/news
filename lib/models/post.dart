import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String postId;
  final String uid;
  final String username;
  final String title;
  final datePublished;
  final String content;
  final String image;

  const Post({
    required this.postId,
    required this.uid,
    required this.username,
    required this.title,
    required this.datePublished,
    required this.content,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'uid': uid,
    'username': username,
    'title': title,
    'datePublished': datePublished,
    'content': content,
    'image': image,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      title: snapshot['title'],
      datePublished: snapshot['datePublished'],
      content: snapshot['content'],
      image: snapshot['image'],
    );
  }

}
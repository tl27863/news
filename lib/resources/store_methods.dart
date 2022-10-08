import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news/models/post.dart';
import 'package:news/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class StoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String uid,
    String username,
    String title,
    String content,
    Uint8List image,
  ) async {
    String res = 'Error!';
    try{
      if (title.isNotEmpty && content.isNotEmpty) {
        String newsImageUrl = await StorageMethods().uploadImageToStorage('posts', image, true);
  
        String postId = const Uuid().v1();
  
        Post post = Post(
          postId: postId, 
          uid: uid, 
          username: username, 
          title: title, 
          datePublished: DateTime.now(), 
          content: content, 
          image: newsImageUrl, 
        );
  
        _firestore.collection('posts').doc(postId).set(post.toJson());
        res = 'success';
      } else {
        res = 'Fields must be filled!';
      }

    } catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(
    String postId,
    String uid,
    String username,
    String profImage,
    String text
  ) async {
    String res = 'Error!';
    try {
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
          'commentId': commentId,
          'uid': uid,
          'username': username,
          'profImage': profImage,
          'text': text,
          'datePublished': DateTime.now()
        });
        res = 'success';
      } else {
        res = ('Comment must be filled!');
      }
    } catch(err){
      res = err.toString();
    }
    return res;
  }
}
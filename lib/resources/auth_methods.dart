import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/models/user.dart' as model;
import 'package:news/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file
  }) async {
    String res = "Error!";
    try {
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = 'success';
      } else {
        res = 'Fields must be filled!';
      }
    } on FirebaseAuthException catch(err) {
      switch (err.code) {
        case 'invalid-email':
          res = 'Email is invalid!';
          break;
        case 'weak-password':
          res = 'Password must be atleast 6 characters!';
          break;
        default:
          res = err.toString();
      }
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = 'Error!';
    try {
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter the email and password!';
      }
    } on FirebaseAuthException catch(err) {
      switch (err.code) {
        case 'wrong-password':
          res = 'Password is Incorrect!';
          break;
        case 'user-not-found':
          res = 'Account doesnt exist!';
          break;
        default:
          res = err.toString();
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
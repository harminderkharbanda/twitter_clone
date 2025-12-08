import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitter_clone/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  final String id;
  final FireBaseUser user;
  LocalUser({required this.id, required this.user});

  copyWith({String? id, FireBaseUser? user}) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier(): super(LocalUser(id: "error", user: FireBaseUser(email: "error", name: "error", profileUrl: "error")));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> signUp(String email) async {
    DocumentReference reference = await _firestore.collection('users').add(FireBaseUser(email: email, name: "No Name", profileUrl: "https://gravatar.com/avatar/?d=mp&s=400").toMap());
    DocumentSnapshot snapshot = await reference.get();
    state = LocalUser(id: reference.id, user: FireBaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  Future<void> signIn(String email) async {
    QuerySnapshot snapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      debugPrint("no users found");
      return;
    }
    if (snapshot.docs.length > 1) {
      debugPrint("more than 1 user with same email");
      return;
    }
    state = LocalUser(id: snapshot.docs[0].id, user: FireBaseUser.fromMap(snapshot.docs[0].data() as Map<String, dynamic>));
  }

  void logout() {
    state = LocalUser(id: "error", user: FireBaseUser(email: "error", name: "error", profileUrl: "error"));
  }

  Future<void> updateName(String name) async {
    await _firestore.collection('users').doc(state.id).update({'name': name});
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updateProfilePic(File image) async {
    Reference reference = _storage.ref().child('users').child(state.id);
    TaskSnapshot snapshot = await reference.putFile(image);
    String profileUrl = await snapshot.ref.getDownloadURL();
    await _firestore.collection('users').doc(state.id).update({'profileUrl': profileUrl});
    state = state.copyWith(user: state.user.copyWith(profileUrl: profileUrl));
  }

}
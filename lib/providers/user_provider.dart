import 'package:cloud_firestore/cloud_firestore.dart';
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
  UserNotifier(): super(LocalUser(id: "error", user: FireBaseUser(email: "error")));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email) async {
    DocumentReference reference = await _firestore.collection('users').add(FireBaseUser(email: email).toMap());
    state = LocalUser(id: reference.id, user: FireBaseUser(email: email));
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
    state = LocalUser(id: snapshot.docs[0].id, user: FireBaseUser(email: email));
  }

  void logout() {
    state = LocalUser(id: "error", user: FireBaseUser(email: "error"));
  }


}
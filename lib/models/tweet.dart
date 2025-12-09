import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String uid;
  final String profileUrl;
  final String name;
  final String tweet;
  final Timestamp postTime;

  Tweet({required this.uid, required this.profileUrl, required this.name, required this.tweet, required this.postTime});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'profileUrl': this.profileUrl,
      'name': this.name,
      'tweet': this.tweet,
      'postTime': this.postTime,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      uid: map['uid'] as String,
      profileUrl: map['profileUrl'] as String,
      name: map['name'] as String,
      tweet: map['tweet'] as String,
      postTime: map['postTime'] as Timestamp,
    );
  }

}
class FireBaseUser {
  String email;
  String name;
  String profileUrl;

  FireBaseUser({required this.email, required this.name, required this.profileUrl});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profileUrl': profileUrl,
    };
  }

  factory FireBaseUser.fromMap(Map<String, dynamic> map) {
    return FireBaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profileUrl: map['profileUrl'] as String,
    );
  }

  copyWith({String? email, String? name, String? profileUrl}) {
    return FireBaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profileUrl: profileUrl ?? this.profileUrl
    );

  }

}
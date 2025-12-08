class FireBaseUser {
  String email;

  FireBaseUser({required this.email});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  factory FireBaseUser.fromMap(Map<String, dynamic> map) {
    return FireBaseUser(
      email: map['email'] as String,
    );
  }}
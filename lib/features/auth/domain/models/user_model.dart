class UserModel {
  final String id;
  final FirebaseUserModel user;

  UserModel({required this.id, required this.user});

  UserModel copyWith({String? id, FirebaseUserModel? user}) {
    return UserModel(id: id ?? this.id, user: user ?? this.user);
  }
}

class FirebaseUserModel {
  final String email;
  final String name;
  final String profilePic;

  const FirebaseUserModel({
    required this.email,
    required this.name,
    required this.profilePic,
  });

  FirebaseUserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
  }) {
    return FirebaseUserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': profilePic,
    };
  }

  factory FirebaseUserModel.fromJson(Map<String, dynamic> json) {
    return FirebaseUserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      profilePic: json['profilePic'] as String,
    );
  }
}

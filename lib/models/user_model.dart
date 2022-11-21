import 'dart:convert';

class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupIdList;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupIdList,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupIdList,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      groupIdList: List<String>.from(
        map['groupId'],
      ),
    );
  }

  String toJson() => json.encode(
        toMap(),
      );

  factory UserModel.fromJson(String source) => UserModel.fromMap(
        json.decode(
          source,
        ),
      );
}

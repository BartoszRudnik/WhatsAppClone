// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String groupPic;
  final String lastMessage;
  final List<String> members;

  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.groupPic,
    required this.lastMessage,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'groupPic': groupPic,
      'lastMessage': lastMessage,
      'members': members,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      groupPic: map['groupPic'] as String,
      lastMessage: map['lastMessage'] as String,
      members: List<String>.from(
        (map['members'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(
        toMap(),
      );

  factory Group.fromJson(String source) => Group.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

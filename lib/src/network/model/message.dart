import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:my_chat_gpt/src/network/model/role.dart';

class XMessage extends Equatable {
  final String msg;
  final MRole role;
  final String image;
  final DateTime time;

  const XMessage({
    required this.msg,
    required this.time,
    this.image = '',
    this.role = MRole.user,
  });

  factory XMessage.newMsg(
    String msg, {
    MRole role = MRole.user,
    String image = '',
  }) {
    return XMessage(
      msg: msg,
      time: DateTime.now(),
      role: role,
      image: image,
    );
  }

  XMessage copyWith({
    String? msg,
    MRole? role,
    String? image,
    DateTime? time,
  }) {
    return XMessage(
      msg: msg ?? this.msg,
      role: role ?? this.role,
      image: image ?? this.image,
      time: time ?? this.time,
    );
  }

  @override
  List<Object> get props => [msg, role, image, time];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'role': role.name,
      'image': image,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory XMessage.fromMap(Map<String, dynamic> map) {
    return XMessage(
      msg: map['msg'] as String,
      role: MRole.fromJson(map['role']),
      image: map['image'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory XMessage.fromJson(String source) =>
      XMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

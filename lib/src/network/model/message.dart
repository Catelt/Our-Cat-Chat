import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:my_chat_gpt/src/network/model/role.dart';

class XMessage extends Equatable {
  final String msg;
  final MRole role;
  final DateTime time;

  const XMessage({
    required this.msg,
    required this.time,
    this.role = MRole.user,
  });

  factory XMessage.newMsg(String msg, {MRole role = MRole.user}) {
    return XMessage(
      msg: msg,
      time: DateTime.now(),
      role: role,
    );
  }

  XMessage copyWith({
    String? msg,
    MRole? role,
    DateTime? time,
  }) {
    return XMessage(
      msg: msg ?? this.msg,
      role: role ?? this.role,
      time: time ?? this.time,
    );
  }

  @override
  List<Object> get props => [msg, role, time];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'role': role.name,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory XMessage.fromMap(Map<String, dynamic> map) {
    return XMessage(
      msg: map['msg'] as String,
      role: MRole.fromJson(map['role']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory XMessage.fromJson(String source) =>
      XMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

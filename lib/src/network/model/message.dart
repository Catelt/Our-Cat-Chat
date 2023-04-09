import 'dart:convert';

class XMessage {
  String msg;
  int indexChat; // 0 is Chat GPT, 1 is user
  DateTime time;

  XMessage({
    required this.msg,
    required this.time,
    this.indexChat = 1,
  });

  factory XMessage.newMsg(String msg, {int indexChat = 1}) {
    return XMessage(
      msg: msg,
      time: DateTime.now(),
      indexChat: indexChat,
    );
  }

  XMessage copyWith({
    String? msg,
    int? indexChat,
    DateTime? time,
  }) {
    return XMessage(
      msg: msg ?? this.msg,
      indexChat: indexChat ?? this.indexChat,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'indexChat': indexChat,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory XMessage.fromMap(Map<String, dynamic> map) {
    return XMessage(
      msg: map['msg'] as String,
      indexChat: map['indexChat'] as int,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory XMessage.fromJson(String source) =>
      XMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

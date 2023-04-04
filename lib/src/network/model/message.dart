// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:my_chat_gpt/src/network/model/content.dart';

class MCandidate extends Equatable {
  final MContent content;

  const MCandidate({
    required this.content,
  });

  MCandidate copyWith({
    MContent? content,
  }) {
    return MCandidate(
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content.toMap(),
    };
  }

  factory MCandidate.fromMap(Map<String, dynamic> map) {
    return MCandidate(
      content: MContent.fromMap(map['content'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MCandidate.fromJson(String source) =>
      MCandidate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [content];
}

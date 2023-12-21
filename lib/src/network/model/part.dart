import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:my_chat_gpt/src/network/model/inline_data.dart';

class MPart extends Equatable {
  final String text;
  final MInlineData? inlineData;
  const MPart({
    this.text = '',
    this.inlineData,
  });

  @override
  List<Object?> get props => [text, inlineData];

  MPart copyWith({
    String? text,
    MInlineData? inlineData,
  }) {
    return MPart(
      text: text ?? this.text,
      inlineData: inlineData ?? this.inlineData,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'text': text,
      'inline_data': inlineData?.toMap() ?? "",
    };
    map.removeWhere((key, value) => value.toString().isEmpty);
    return map;
  }

  factory MPart.fromMap(Map<String, dynamic> map) {
    return MPart(
      text: map['text'] as String,
      inlineData: map['inline_data'] != null
          ? MInlineData.fromMap(map['inlineData'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MPart.fromJson(String source) =>
      MPart.fromMap(json.decode(source) as Map<String, dynamic>);
}

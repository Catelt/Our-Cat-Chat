import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'content.dart';

class MGeminiRequest extends Equatable {
  final List<MContent> contents;
  const MGeminiRequest({
    required this.contents,
  });

  MGeminiRequest copyWith({
    List<MContent>? contents,
  }) {
    return MGeminiRequest(
      contents: contents ?? this.contents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contents': contents.map((x) => x.toMap()).toList(),
    };
  }

  factory MGeminiRequest.fromMap(Map<String, dynamic> map) {
    return MGeminiRequest(
      contents: List<MContent>.from(
        (map['contents'] as List<int>).map<MContent>(
          (x) => MContent.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MGeminiRequest.fromJson(String source) =>
      MGeminiRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [contents];
}

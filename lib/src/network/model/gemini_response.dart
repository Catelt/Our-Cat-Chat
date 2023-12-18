import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:my_chat_gpt/src/network/model/candidate.dart';

class MGeminiResponse extends Equatable {
  final List<MCandidate> candidates;
  const MGeminiResponse({
    required this.candidates,
  });

  MGeminiResponse copyWith({
    List<MCandidate>? candidates,
  }) {
    return MGeminiResponse(
      candidates: candidates ?? this.candidates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'candidates': candidates.map((x) => x.toMap()).toList(),
    };
  }

  factory MGeminiResponse.fromMap(Map<String, dynamic> map) {
    return MGeminiResponse(
      candidates: List<MCandidate>.from(
        (map['candidates'] as List<dynamic>).map<MCandidate>(
          (x) => MCandidate.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MGeminiResponse.fromJson(String source) =>
      MGeminiResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [candidates];
}

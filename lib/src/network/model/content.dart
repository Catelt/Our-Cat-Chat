import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'role.dart';

class MPart extends Equatable {
  final String text;
  const MPart({
    this.text = '',
  });

  @override
  List<Object> get props => [text];

  MPart copyWith({
    String? text,
  }) {
    return MPart(
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
    };
  }

  factory MPart.fromMap(Map<String, dynamic> map) {
    return MPart(
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MPart.fromJson(String source) =>
      MPart.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MContent extends Equatable {
  final MRole role;
  final List<MPart> parts;

  const MContent({
    this.role = MRole.user,
    required this.parts,
  });

  MContent copyWith({
    MRole? role,
    List<MPart>? parts,
  }) {
    return MContent(
      role: role ?? this.role,
      parts: parts ?? this.parts,
    );
  }

  @override
  List<Object> get props => [role, parts];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role.name,
      'parts': parts.map((x) => x.toMap()).toList(),
    };
  }

  factory MContent.fromMap(Map<String, dynamic> map) {
    return MContent(
      role: MRole.fromJson(map['role']),
      parts: List<MPart>.from(
        (map['parts'] as List<dynamic>).map<MPart>(
          (x) => MPart.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MContent.fromJson(String source) =>
      MContent.fromMap(json.decode(source) as Map<String, dynamic>);
}

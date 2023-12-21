import 'dart:convert';

import 'package:equatable/equatable.dart';

class MInlineData extends Equatable {
  final String data;
  final String mimeType;
  const MInlineData({
    required this.data,
    this.mimeType = 'image/jpeg',
  });

  MInlineData copyWith({
    String? data,
    String? mimeType,
  }) {
    return MInlineData(
      data: data ?? this.data,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  List<Object> get props => [data, mimeType];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'mime_type': mimeType,
    };
  }

  factory MInlineData.fromMap(Map<String, dynamic> map) {
    return MInlineData(
      data: map['data'] as String,
      mimeType: map['mime_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MInlineData.fromJson(String source) =>
      MInlineData.fromMap(json.decode(source) as Map<String, dynamic>);
}

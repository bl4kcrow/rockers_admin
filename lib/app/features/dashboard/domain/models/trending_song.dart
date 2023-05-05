// To parse this JSON data, do

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TrendingSong {
  TrendingSong({
    this.id,
    required this.priority,
    required this.songId,
  });

  final String? id;
  final int priority;
  final String songId;

  TrendingSong copyWith({
    String? id,
    int? priority,
    String? songId,
  }) =>
      TrendingSong(
        id: id ?? this.id,
        priority: priority ?? this.priority,
        songId: songId ?? this.songId,
      );

  factory TrendingSong.fromJson(String str) =>
      TrendingSong.fromMap(json.decode(str));

  factory TrendingSong.fromSnapshot(DocumentSnapshot snapshot) => TrendingSong(
        id: snapshot.reference.id,
        priority: snapshot.get('priority'),
        songId: snapshot.get('songId'),
      );

  String toJson() => json.encode(toMap());

  factory TrendingSong.fromMap(Map<String, dynamic> json) => TrendingSong(
        id: json['id'],
        priority: json['priority'],
        songId: json['songId'],
      );

  Map<String, dynamic> toMap() => {
        'priority': priority,
        'songId': songId,
      };

  Map<String, dynamic> mapToUpdate() => {
        'priority': priority,
      };
}

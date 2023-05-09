// To parse this JSON data, do

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TrendingSong {
  TrendingSong({
    this.id,
    required this.band,
    required this.priority,
    required this.songId,
    required this.title,
    this.trendType = TrendType.newRelease,
    required this.videoUrl,
  });

final String band;
  final String? id;
  final int priority;
  final String songId;
  final String title;
  final TrendType trendType;
  final String videoUrl;

  TrendingSong copyWith({
    String? id,
    String? band,
    int? priority,
    String? songId,
    String? title,
    TrendType? trendType,
    String? videoUrl,
  }) =>
      TrendingSong(
        id: id ?? this.id,
        band: band ?? this.band,
        priority: priority ?? this.priority,
        songId: songId ?? this.songId,
        title: title ?? this.title,
        trendType: trendType ?? this.trendType,
        videoUrl: videoUrl ?? this.videoUrl,
      );

  factory TrendingSong.fromJson(String str) =>
      TrendingSong.fromMap(json.decode(str));

  factory TrendingSong.fromSnapshot(DocumentSnapshot snapshot) => TrendingSong(
        id: snapshot.reference.id,
        band: snapshot.get('band'),
        priority: snapshot.get('priority'),
        songId: snapshot.get('songId'),
        title: snapshot.get('title'),
        trendType: TrendType.fromJson(snapshot.get('trendType')),
        videoUrl: snapshot.get('videoUrl'),
      );

  String toJson() => json.encode(toMap());

  factory TrendingSong.fromMap(Map<String, dynamic> json) => TrendingSong(
        id: json['id'],
        band: json['band'],
        priority: json['priority'],
        songId: json['songId'],
        title: json['title'],
        trendType: TrendType.fromJson(json['trendType']),
        videoUrl: json['videoUrl'],
      );

  Map<String, dynamic> toMap() => {
        'band': band,
        'priority': priority,
        'songId': songId,
        'title': title,
        'trendType': trendType.name,
        'videoUrl': videoUrl,
      };

  Map<String, dynamic> mapToUpdate() => {
        'priority': priority,
        'trendType': trendType.name,
      };
}

enum TrendType {
  recommendation('Recommendation'),
  newRelease('New Release');

  const TrendType(this.description);
  final String description;

  String toJson() => name;
  static TrendType fromJson(String json) => values.byName(json);
}

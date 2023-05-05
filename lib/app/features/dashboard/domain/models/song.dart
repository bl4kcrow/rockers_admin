// To parse this JSON data, do
//
//     final song = songFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  Song({
    this.id,
    required this.band,
    required this.title,
    required this.creationDate,
    required this.videoUrl,
  });

  final String? id;
  final String band;
  final String title;
  final DateTime creationDate;
  final String videoUrl;

  Song copyWith({
    String? id,
    String? band,
    String? title,
    DateTime? creationDate,
    String? videoUrl,
  }) =>
      Song(
        id: id ?? this.id,
        band: band ?? this.band,
        title: title ?? this.title,
        creationDate: creationDate ?? this.creationDate,
        videoUrl: videoUrl ?? this.videoUrl,
      );

  factory Song.fromJson(String str) => Song.fromMap(json.decode(str));

  factory Song.fromSnapshot(DocumentSnapshot snapshot) => Song(
        id: snapshot.reference.id,
        band: snapshot.get('band'),
        title: snapshot.get('title'),
        creationDate: snapshot.get('creationDate').toDate().toLocal(),
        videoUrl: snapshot.get('videoUrl'),
      );

  String toJson() => json.encode(toMap());

  factory Song.fromMap(Map<String, dynamic> json) => Song(
        id: json['id'],
        band: json['band'],
        title: json['title'],
        creationDate: json['creationDate'].toDate().toLocal(),
        videoUrl: json['videoUrl'],
      );

  Map<String, dynamic> toMap() => {
        'band': band,
        'title': title,
        'creationDate': Timestamp.fromDate(creationDate),
        'videoUrl': videoUrl,
      };

  Map<String, dynamic> mapToUpdate() => {
        'band': band,
        'title': title,
        'videoUrl': videoUrl,
      };
}

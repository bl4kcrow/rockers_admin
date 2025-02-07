import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class Playlist {
  Playlist({
    this.id,
    required this.isActive,
    required this.name,
    required this.priority,
    required this.rankingEnabled,
    this.songsId,
    required this.songReferences,
    required this.creationDate,
    required this.lastUpdate,
  });

  final String? id;
  final bool isActive;
  final String name;
  final int priority;
  final bool rankingEnabled;
  final List<String>? songsId;
  final List<SongReference> songReferences;
  final DateTime creationDate;
  final DateTime lastUpdate;

  factory Playlist.fromJson(String str) => Playlist.fromMap(json.decode(str));

  factory Playlist.fromMap(Map<String, dynamic> json) => Playlist(
        id: json['id'],
        isActive: json['isActive'],
        name: json['name'],
        priority: json['priority'],
        rankingEnabled: json['rankingEnabled'],
        songsId: List<String>.from(
          json['songsId'].map((songId) => songId),
        ),
        songReferences: List<SongReference>.from(
          json['songs'].map(
            (songData) => SongReference.fromMap(songData),
          ),
        ),
        creationDate: json['creationDate'].toDate().toLocal(),
        lastUpdate: json['lastUpdate'].toDate().toLocal(),
      );

  factory Playlist.fromSnapshot(DocumentSnapshot snapshot) {
    final doc = snapshot.data() as Map<String, dynamic>;

    return Playlist(
      id: snapshot.reference.id,
      isActive: doc['isActive'],
      name: doc['name'],
      priority: doc['priority'],
      rankingEnabled: doc['rankingEnabled'],
      songsId: doc.containsKey('songsId')
          ? List<String>.from(
              doc['songsId'].map((songId) => songId),
            )
          : null,
      songReferences: List<SongReference>.from(
        doc['songs'].map(
          (item) => SongReference.fromMap(item),
        ),
      ),
      creationDate: doc['creationDate'].toDate().toLocal(),
      lastUpdate: doc['lastUpdate'].toDate().toLocal(),
    );
  }

  Playlist copyWith({
    String? id,
    bool? isActive,
    String? name,
    int? priority,
    bool? rankingEnabled,
    List<String>? songsId,
    List<SongReference>? songReferences,
    DateTime? creationDate,
    DateTime? lastUpdate,
  }) =>
      Playlist(
        id: id ?? this.id,
        isActive: isActive ?? this.isActive,
        name: name ?? this.name,
        priority: priority ?? this.priority,
        rankingEnabled: rankingEnabled ?? this.rankingEnabled,
        songsId: songsId ?? this.songsId,
        songReferences: songReferences ?? this.songReferences,
        creationDate: creationDate ?? this.creationDate,
        lastUpdate: lastUpdate ?? this.lastUpdate,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'isActive': isActive,
        'name': name,
        'priority': priority,
        'rankingEnabled': rankingEnabled,
        'songsId': List<String>.from(
          songReferences.map((songReference) => songReference.songId),
        ),
        'songs': List<dynamic>.from(
          songReferences.map(
            (item) => item.toMap(),
          ),
        ),
        'creationDate': Timestamp.fromDate(creationDate),
        'lastUpdate': Timestamp.fromDate(lastUpdate),
      };
}

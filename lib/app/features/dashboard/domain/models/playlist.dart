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
    required this.songReferences,
    required this.creationDate,
    required this.lastUpdate,
  });

  final String? id;
  final bool isActive;
  final String name;
  final int priority;
  final bool rankingEnabled;
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
        songReferences: List<SongReference>.from(
          json['songs'].map(
            (x) => SongReference.fromMap(x),
          ),
        ),
        creationDate: json['creationDate'].toDate().toLocal(),
        lastUpdate: json['lastUpdate'].toDate().toLocal(),
      );

  factory Playlist.fromSnapshot(DocumentSnapshot snapshot) => Playlist(
        id: snapshot.reference.id,
        isActive: snapshot.get('isActive'),
        name: snapshot.get('name'),
        priority: snapshot.get('priority'),
        rankingEnabled: snapshot.get('rankingEnabled'),
        songReferences: List<SongReference>.from(
          snapshot.get('songs').map(
                (item) => SongReference.fromMap(item),
              ),
        ),
        creationDate: snapshot.get('creationDate').toDate().toLocal(),
        lastUpdate: snapshot.get('lastUpdate').toDate().toLocal(),
      );

  Playlist copyWith({
    String? id,
    bool? isActive,
    String? name,
    int? priority,
    bool? rankingEnabled,
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
        'songs': List<dynamic>.from(
          songReferences.map(
            (item) => item.toMap(),
          ),
        ),
        'creationDate': Timestamp.fromDate(creationDate),
        'lastUpdate': Timestamp.fromDate(lastUpdate),
      };
}

import 'dart:convert';

class SongReference {
  SongReference({
    required this.band,
    required this.position,
    required this.songId,
    required this.title,
    required this.videoUrl,
  });
  
  final String band;
  final int position;
  final String songId;
  final String title;
  final String videoUrl;

  factory SongReference.fromJson(String str) =>
      SongReference.fromMap(json.decode(str));

  factory SongReference.fromMap(Map<String, dynamic> json) => SongReference(
        band: json['band'],
        position: json['position'],
        songId: json['songId'],
        title: json['title'],
        videoUrl: json['videoUrl'],
      );

  SongReference copyWith({
    String? band,
    int? position,
    String? songId,
    String? title,
    String? videoUrl,
  }) =>
      SongReference(
        band: band ?? this.band,
        position: position ?? this.position,
        songId: songId ?? this.songId,
        title: title ?? this.title,
        videoUrl: videoUrl ?? this.videoUrl,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'band': band,
        'position': position,
        'songId': songId,
        'title': title,
        'videoUrl': videoUrl,
      };
}

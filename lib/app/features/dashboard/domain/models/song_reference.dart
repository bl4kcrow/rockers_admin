import 'dart:convert';

class SongReference {
  final int position;
  final String songId;

  SongReference({
    required this.position,
    required this.songId,
  });

  factory SongReference.fromJson(String str) =>
      SongReference.fromMap(json.decode(str));

  factory SongReference.fromMap(Map<String, dynamic> json) => SongReference(
        position: json['position'],
        songId: json['songId'],
      );

  SongReference copyWith({
    int? position,
    String? songId,
  }) =>
      SongReference(
        position: position ?? this.position,
        songId: songId ?? this.songId,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'position': position,
        'songId': songId,
      };
}

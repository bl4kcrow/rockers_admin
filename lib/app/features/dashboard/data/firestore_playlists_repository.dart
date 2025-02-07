import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final firestorePlaylistsRepositoryProvider =
    Provider<FirestorePlaylistsRepository>(
  (ref) => FirestorePlaylistsRepository(),
);

class FirestorePlaylistsRepository implements IPlaylistsRepository {
  final _collection = FirebaseFirestore.instance.collection('playlists');

  @override
  Future<String> add(Playlist playlist) async {
    String id = '';

    await _collection.add(playlist.toMap()).then((doc) => id = doc.id);

    return id;
  }

  @override
  Future<List<Playlist>> getAll() async {
    final List<Playlist> playlists = [];

    final Query query = _collection.orderBy('priority');
    final QuerySnapshot querySnapshot = await query.get();

    playlists.addAll(
      querySnapshot.docs.map(
        (doc) => Playlist.fromSnapshot(doc),
      ),
    );

    return playlists;
  }

  @override
  Future<void> remove(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<void> updateData(Playlist playlist) async {
    await _collection.doc(playlist.id).update(playlist.toMap());
  }

  @override
  Future<void> updatePriority(
    String playlistId,
    int newPriority,
  ) async {
    await _collection.doc(playlistId).update({'priority': newPriority});
  }

  @override
  Future<void> updateSong(Song songToUpdate) async {
    final QuerySnapshot<Map<String, dynamic>> query = await _collection
        .where(
          'songsId',
          arrayContains: songToUpdate.id,
        )
        .get();

    for (var doc in query.docs) {
      final List<dynamic> songs = doc.data()['songs'];

      for (var song in songs) {
        if (song['songId'] == songToUpdate.id) {
          song['band'] = songToUpdate.band;
          song['title'] = songToUpdate.title;
          song['videoUrl'] = songToUpdate.videoUrl;
        }
      }

      doc.reference.update({'songs': songs});
    }
  }
}

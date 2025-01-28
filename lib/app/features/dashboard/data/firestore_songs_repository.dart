import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final firestoreSongsRepositoryProvider = Provider<FirestoreSongsRepository>(
  (ref) => FirestoreSongsRepository(),
);

class FirestoreSongsRepository implements ISongsRepository {
  final _collection = FirebaseFirestore.instance.collection('songs');

  @override
  Future<String> add(Song song) async {
    String id = '';

    await _collection.add(song.toMap()).then((doc) => id = doc.id);

    return id;
  }

  @override
  Future<List<Song>> getAll() async {
    final List<Song> songs = [];
    final Query query = _collection.orderBy('band');
    final QuerySnapshot querySnapshot = await query.get();

    songs.addAll(
      querySnapshot.docs
          .map(
            (doc) => Song.fromSnapshot(doc),
          )
          .toList(),
    );

    return songs;
  }

  @override
  Future<List<Song>> getFiltered(String band) async {
    final List<Song> songs = [];
    final Query query = _collection
        .where(
          'band',
          isGreaterThanOrEqualTo: band,
        )
        .where(
          'band',
          isLessThan: '${band}z',
        )
        .orderBy('title');

    final QuerySnapshot querySnapshot = await query.get();

    songs.addAll(
      querySnapshot.docs
          .map(
            (doc) => Song.fromSnapshot(doc),
          )
          .toList(),
    );

    return songs;
  }

  @override
  Future<void> remove(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<void> update(Song song) async {
    await _collection.doc(song.id).update(song.mapToUpdate());
  }

  @override
  Future<List<Song>> getById(List<String> ids) async {
    final List<Song> songs = [];
    final Query query = _collection.where(
      FieldPath.documentId,
      whereIn: ids,
    );

    final QuerySnapshot querySnapshot = await query.get();

    songs.addAll(
      querySnapshot.docs
          .map(
            (doc) => Song.fromSnapshot(doc),
          )
          .toList(),
    );

    return songs;
  }
}

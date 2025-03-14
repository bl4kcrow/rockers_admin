import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final firestoreTrendingRepositoryProvider =
    Provider<FirestoreTrendingRepository>(
        (ref) => FirestoreTrendingRepository());

class FirestoreTrendingRepository implements ITrendingRepository {
  final _collection = FirebaseFirestore.instance.collection('trending');

  @override
  Future<String> add(TrendingSong trendingSong) async {
    String id = '';

    await _collection.add(trendingSong.toMap()).then((doc) => id = doc.id);

    return id;
  }

  @override
  Future<List<TrendingSong>> get() async {
    final List<TrendingSong> trendingSongs = [];
    final Query query = _collection.orderBy('priority');
    final QuerySnapshot querySnapshot = await query.get();

    trendingSongs.addAll(
      querySnapshot.docs
          .map(
            (doc) => TrendingSong.fromSnapshot(doc),
          )
          .toList(),
    );

    return trendingSongs;
  }

  @override
  Future<void> remove(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<void> update(TrendingSong trendingSong) async {
    await _collection.doc(trendingSong.id).update(trendingSong.mapToUpdate());
  }

  @override
  Future<List<TrendingSong>> save(
    List<TrendingSong> trendingSongList,
    List<String> idSongsToDelete,
  ) async {
    final List<TrendingSong> trendingSongsSaved = [];

    for (var idSong in idSongsToDelete) {
      await remove(idSong);
    }

    for (var trendingSong in trendingSongList) {
      if (trendingSong.id != null) {
        await _collection
            .doc(trendingSong.id)
            .update(trendingSong.mapToUpdate());
        trendingSongsSaved.add(trendingSong);
      } else {
        final idAssigned = await add(trendingSong);

        trendingSongsSaved.add(
          trendingSong.copyWith(id: idAssigned),
        );
      }
    }

    return trendingSongsSaved;
  }
  
  @override
  Future<void> updateSong(Song songToUpdate) async {
    final QuerySnapshot<Map<String, dynamic>> query =
        await _collection.where('songId', isEqualTo: songToUpdate.id).get();

    if (query.docs.isNotEmpty) {
      query.docs.first.reference.update({
        'band': songToUpdate.band,
        'title': songToUpdate.title,
        'videoUrl': songToUpdate.videoUrl,
      });
    }
  }
}

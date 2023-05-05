import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

//* Base Song Repository Interface

final songsRepositoryProvider = Provider<ISongsRepository>(
  (ref) => ref.watch(firestoreSongsRepositoryProvider),
);

abstract class ISongsRepository {
  Future<String> add(Song song);

  Future<void> remove(String id);

  Future<void> update(Song song);

  Future<List<Song>> getAll();

  Future<List<Song>> getById(List<String> ids);

  Future<List<Song>> getFiltered(String band);
}

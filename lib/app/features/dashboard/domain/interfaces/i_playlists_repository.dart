import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final playlistRepositoryProvider = Provider<IPlaylistsRepository>(
  (ref) => ref.watch(firestorePlaylistsRepositoryProvider),
);

abstract class IPlaylistsRepository {
  Future<String> add(Playlist playlist);
  Future<void> remove(String id);
  Future<void> updateData(Playlist playlist);
  Future<void> updatePriority(
    String playlistId,
    int newPriority,
  );
  Future<List<Playlist>> getAll();
}

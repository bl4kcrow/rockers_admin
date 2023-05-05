import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final songsProvider =
    AsyncNotifierProvider<SongsNotifier, List<Song>>(SongsNotifier.new);

class SongsNotifier extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async {
    final songsRepository = ref.read(songsRepositoryProvider);
    return await songsRepository.getAll();
  }

  Future add(Song song) async {
    final songsRepository = ref.read(songsRepositoryProvider);
    final id = await songsRepository.add(song);

    if (id.isNotEmpty) {
      await update((currentList) {
        currentList.add(song.copyWith(id: id));
        currentList.sort((songA, songB) => songA.band.compareTo(songB.band));
        return currentList;
      });
    }
  }

  Future filter(String band) async {
    final songsRepository = ref.read(songsRepositoryProvider);

    await update((currentList) async =>
        currentList = await songsRepository.getFiltered(band));
  }

  Future remove(String id) async {
    final songsRepository = ref.read(songsRepositoryProvider);
    await songsRepository.remove(id);

    await update((currentList) {
      currentList.removeWhere((song) => song.id == id);
      return currentList;
    });
  }

  Future updateData(Song song) async {
    final songsRepository = ref.read(songsRepositoryProvider);
    await songsRepository.update(song);

    await update(
      (currentList) {
        final indexToUpdate =
            currentList.indexWhere((element) => element.id == song.id);
        currentList[indexToUpdate] = song;
        return currentList;
      },
    );
  }
}

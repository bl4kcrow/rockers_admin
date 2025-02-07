import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final playlistsProvider =
    AsyncNotifierProvider<PlaylistsNotifier, List<Playlist>>(
        PlaylistsNotifier.new);

class PlaylistsNotifier extends AsyncNotifier<List<Playlist>> {
  @override
  Future<List<Playlist>> build() async {
    final playlistRepository = ref.read(playlistRepositoryProvider);
    return await playlistRepository.getAll();
  }

  Future<String> add(Playlist playlist) async {
    final playlistRepository = ref.read(playlistRepositoryProvider);
    final playlistId = await playlistRepository.add(playlist);

    update((currentList) {
      currentList.add(
        playlist.copyWith(id: playlistId),
      );

      return currentList;
    });

    return playlistId;
  }

  Future addSongToPlaylist(
    String playlistId,
    SongReference songReference,
  ) async {
    await update(
      (currentList) {
        currentList
            .singleWhere((playlist) => playlist.id == playlistId)
            .songReferences
            .add(songReference);

        return currentList;
      },
    );
  }

  Future updatePlaylist(Playlist playlist) async {
    final List<SongReference> songReferencesSorted = [];
    final playlistRepository = ref.read(playlistRepositoryProvider);

    var index = 1;

    for (var songReference in playlist.songReferences) {
      songReferencesSorted.add(songReference.copyWith(position: index++));
    }

    final playlistSorted = playlist.copyWith(
      songReferences: songReferencesSorted,
      lastUpdate: DateTime.now().toUtc(),
    );

    await playlistRepository.updateData(playlistSorted);

    await update((currentList) {
      final playlistIndex = currentList.indexWhere(
        (playlist) => playlist.id == playlistSorted.id,
      );

      currentList[playlistIndex] = playlistSorted;

      return currentList;
    });
  }

  Future updatePlaylistsPriority() async {
    final playlistRepository = ref.read(playlistRepositoryProvider);
    final List<Playlist> playlistsSorted = [];

    await update((currentList) async {
      var index = 1;

      for (var playlist in currentList) {
        var newIndex = index++;

        playlistsSorted.add(
          playlist.copyWith(
            priority: newIndex,
          ),
        );
        await playlistRepository.updatePriority(
          playlist.id!,
          newIndex,
        );
      }

      return playlistsSorted;
    });
  }

  Future removePlaylist(String playlistId) async {
    final playlistRepository = ref.read(playlistRepositoryProvider);

    await playlistRepository.remove(playlistId);

    await update((currentList) {
      currentList.removeWhere((playlist) => playlist.id == playlistId);
      return currentList;
    });
  }

  Future removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    await update((currentList) {
      currentList
          .singleWhere((playlist) => playlist.id == playlistId)
          .songReferences
          .removeWhere((songReference) => songReference.songId == songId);
      return currentList;
    });
  }

  Future updateSongReference(Song song) async {
    final playlistRepository = ref.read(playlistRepositoryProvider);

    await playlistRepository.updateSong(song);

    await update((currentList) {
      final List<int> listToUpdate = currentList
          .asMap()
          .entries
          .where(
            (entries) => entries.value.songReferences
                .any((songs) => songs.songId == song.id),
          )
          .map((entry) => entry.key)
          .toList();

      for (var playlistIndex in listToUpdate) {
        int songReferenceIndex = currentList[playlistIndex]
            .songReferences
            .indexWhere((element) => element.songId == song.id);

        currentList[playlistIndex].songReferences[songReferenceIndex] =
            currentList[playlistIndex]
                .songReferences[songReferenceIndex]
                .copyWith(
                  band: song.band,
                  title: song.title,
                  videoUrl: song.videoUrl,
                );
      }

      return currentList;
    });
  }
}

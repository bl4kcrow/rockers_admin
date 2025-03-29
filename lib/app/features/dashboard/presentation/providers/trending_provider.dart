import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final trendingProvider =
    AsyncNotifierProvider<TrendingNotifier, List<TrendingSong>>(
        TrendingNotifier.new);

class TrendingNotifier extends AsyncNotifier<List<TrendingSong>> {
  @override
  Future<List<TrendingSong>> build() async {
    final trendingRepository = ref.read(trendingRepositoryProvider);
    return await trendingRepository.get();
  }

  final List<String> idsToDelete = [];

  Future add(
    int index,
    TrendingSong trendingSong,
  ) async {
    await update((currentList) {
      currentList.insert(
        index,
        trendingSong,
      );
      return currentList;
    });
  }

  Future remove(String id) async {
    await update((currentList) {
      currentList.removeWhere((trendingSong) => trendingSong.id == id);
      idsToDelete.add(id);
      return currentList;
    });
  }

  Future removeByIndex(
    int index, {
    bool isReorder = false,
  }) async {
    await update((currentList) {
      final songToDelete = currentList.removeAt(index);
      if (isReorder == false && songToDelete.id != null) {
        idsToDelete.add(songToDelete.id!);
      }
      return currentList;
    });
  }

  Future save() async {
    final trendingRepository = ref.read(trendingRepositoryProvider);
    final List<TrendingSong> listWithNewPriority = [];

    await update((currentList) async {
      var index = 1;

      for (var trendingSong in currentList) {
        listWithNewPriority.add(
          trendingSong.copyWith(
            priority: index++,
          ),
        );
      }

      final trendingSongsSaved = await trendingRepository.save(
        listWithNewPriority,
        idsToDelete,
      );

      idsToDelete.clear();

      return trendingSongsSaved;
    });
  }

  Future updateSong(Song songToUpdate) async {
    final trendingRepository = ref.read(trendingRepositoryProvider);

    await update((currentList) async {
      int indexToChange = -1;

      indexToChange = currentList.indexWhere(
        ((trendingItem) => trendingItem.songId == songToUpdate.id),
      );

      if (indexToChange != -1) {
        await trendingRepository.updateSong(songToUpdate);

        currentList[indexToChange] = currentList[indexToChange].copyWith(
          band: songToUpdate.band,
          title: songToUpdate.title,
          videoUrl: songToUpdate.videoUrl,
        );
      }

      return currentList;
    });
  }

  Future updateTrendType({
    required TrendingSong trendingSong,
    required TrendType trendType,
  }) async {
    int indexToChange = 0;

    await update((currentList) {
      if (trendingSong.id != null) {
        indexToChange = currentList.indexWhere(
          ((trendingItem) => trendingItem.id == trendingSong.id),
        );
      } else {
        indexToChange = currentList.indexWhere(
          ((trendingItem) => trendingItem.songId == trendingSong.songId),
        );
      }

      currentList.removeAt(indexToChange);
      currentList.insert(
        indexToChange,
        trendingSong.copyWith(trendType: trendType),
      );

      return currentList;
    });
  }
}

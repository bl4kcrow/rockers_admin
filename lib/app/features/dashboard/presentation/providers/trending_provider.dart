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

  Future removeByIndex(int index) async {
    await update((currentList) {
      final songToDelete = currentList.removeAt(index);
      if (songToDelete.id != null) {
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

  Future updateTrendType({
    required TrendingSong trendingSong,
    required TrendType trendType,
  }) async {
    await update((currentList) {
      final int indexToChange = currentList.indexWhere(
        ((trendingItem) => trendingItem.id == trendingSong.id),
      );

      currentList.removeAt(indexToChange);
      currentList.insert(
        indexToChange,
        trendingSong.copyWith(trendType: trendType),
      );

      return currentList;
    });
  }
}

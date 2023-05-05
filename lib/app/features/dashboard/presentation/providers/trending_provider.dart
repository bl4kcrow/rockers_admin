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

  Future add(TrendingSong trendingSong) async {
    await update((currentList) {
      currentList.insert(0, trendingSong);
      return currentList;
    });
  }

  Future remove(String id) async {
    final trendingRepository = ref.read(trendingRepositoryProvider);
    trendingRepository.remove(id);

    await update((currentList) {
      currentList.removeWhere((trendingSong) => trendingSong.id == id);
      return currentList;
    });
  }

  Future save() async {
    final trendingRepository = ref.read(trendingRepositoryProvider);

    await update((currentList) async {
      final List<TrendingSong> listWithNewPriority = [];
      var index = 1;

      for (var trendingSong in currentList) {
        listWithNewPriority.add(
          trendingSong.copyWith(
            priority: index++,
          ),
        );
      }

      await trendingRepository.save(listWithNewPriority);
      return listWithNewPriority;
    });
  }
}

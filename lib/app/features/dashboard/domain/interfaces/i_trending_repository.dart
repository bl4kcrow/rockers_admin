import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

final trendingRepositoryProvider = Provider<ITrendingRepository>((ref) {
  return FirestoreTrendingRepository();
});

abstract class ITrendingRepository {
  Future<String> add(TrendingSong trendingSong);
  Future<void> update(TrendingSong trendingSong);
  Future<void> remove(String id);
  Future<List<TrendingSong>> get();
  Future<void> save(List<TrendingSong> trendingSongList);
}

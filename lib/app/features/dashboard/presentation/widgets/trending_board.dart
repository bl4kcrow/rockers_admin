import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/core/widgets/snack_bar.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class TrendingBoard extends ConsumerWidget {
  const TrendingBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingSongList = ref.watch(trendingProvider);
    final trendingSongNotifier = ref.read(trendingProvider.notifier);

    return trendingSongList.when(
      data: (trendingSongs) {
        return Column(
          children: [
            SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Playlist',
                    style: heading2Style,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add'),
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: AppColors.eerieBlack.withOpacity(0.5),
                      builder: (context) {
                        return const SongToPlaylistDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final songData = trendingSongs[index];

                    return ListTile(
                      key: Key('$index'),
                      leading: Text(
                        NumberFormat('00').format(index + 1),
                        style: heading2Style,
                      ),
                      title: Text(songData.title),
                      subtitle: Text(
                        songData.band,
                        style: captionStyle,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<TrendType>(
                              value: trendingSongs[index].trendType,
                              focusColor: Colors.transparent,
                              items: TrendType.values
                                  .map(
                                    (trendType) => DropdownMenuItem(
                                      value: trendType,
                                      child: Text(trendType.description),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  trendingSongNotifier.updateTrendType(
                                    trendingSong: trendingSongs[index],
                                    trendType: newValue,
                                  );
                                }
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                await trendingSongNotifier.removeByIndex(
                                  index,
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outlined,
                                color: AppColors.frenchWine,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: trendingSongs.length,
                  onReorder: (oldIndex, newIndex) {
                    // setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final TrendingSong item = trendingSongs[oldIndex];
                    trendingSongNotifier.removeByIndex(
                      oldIndex,
                    );
                    trendingSongNotifier.add(
                      newIndex,
                      item,
                    );
                    // });
                  },
                ),
              ),
            ),
            BoardFooter(
              onPressedSave: () async {
                await trendingSongNotifier.save();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(text: 'Trending Playlist Saved'),
                  );
                }
              },
              onPressedCancel: () {
                ref.invalidate(trendingProvider);
              },
            ),
          ],
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

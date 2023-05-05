import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/core/widgets/snack_bar.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class TrendingBoard extends ConsumerStatefulWidget {
  const TrendingBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrendingBoardState();
}

class _TrendingBoardState extends ConsumerState<TrendingBoard> {
  @override
  Widget build(BuildContext context) {
    final trendingSongList = ref.watch(trendingProvider);
    final trendingSongNotifier = ref.read(trendingProvider.notifier);
    final songsData = ref.read(songsProvider).asData?.value;

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
                    final songData = songsData?.firstWhere(
                      (song) => song.id == trendingSongs[index].songId,
                    );

                    return ListTile(
                      key: Key('$index'),
                      leading: Text(
                        NumberFormat('00').format(index + 1),
                        style: heading2Style,
                      ),
                      title: Text(songData?.title ?? 'N/A'),
                      subtitle: Text(
                        songData?.band ?? 'N/A',
                        style: captionStyle,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: IconButton(
                          onPressed: () async {
                            await trendingSongNotifier.remove(
                              trendingSongs[index].id!,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: AppColors.frenchWine,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: trendingSongs.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final TrendingSong item =
                          trendingSongs.removeAt(oldIndex);
                      trendingSongs.insert(
                        newIndex,
                        item,
                      );
                    });
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

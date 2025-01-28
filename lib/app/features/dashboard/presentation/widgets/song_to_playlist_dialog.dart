import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class SongToPlaylistDialog extends ConsumerStatefulWidget {
  const SongToPlaylistDialog({
    super.key,
    this.playlist,
  });

  final Playlist? playlist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SongToPlaylistDialogState();
}

class _SongToPlaylistDialogState extends ConsumerState<SongToPlaylistDialog> {
  final searchController = TextEditingController();

  bool isSearching = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songList = ref.watch(songsProvider);
    final playlistsNotifier = ref.read(playlistsProvider.notifier);
    final trendingSongsNotifier = ref.read(trendingProvider.notifier);

    return AlertDialog(
      title: const Text('Add song to the playlist'),
      content: SizedBox(
        height: 400,
        width: 400,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isSearching == true) {
                          isSearching = false;
                          searchController.clear();
                          ref.invalidate(songsProvider);
                        } else if (searchController.text.isNotEmpty) {
                          isSearching = true;
                          ref
                              .read(songsProvider.notifier)
                              .filter(searchController.text);
                        }
                      });
                    },
                    icon: Icon(
                      isSearching == true
                          ? Icons.cancel_outlined
                          : Icons.search_outlined,
                    ),
                  ),
                ),
              ),
            ),
            ...[
              songList.when(
                data: (songs) => Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(songs[index].title),
                        subtitle: Text(songs[index].band),
                        trailing: IconButton(
                          onPressed: () async {
                            final playlistId = widget.playlist?.id;

                            if (playlistId != null && playlistId.isNotEmpty) {
                              final currentSongs =
                                  widget.playlist?.songReferences;

                              await playlistsNotifier.addSongToPlaylist(
                                playlistId,
                                SongReference(
                                  band: songs[index].band,
                                  position: currentSongs?.isNotEmpty == true
                                      ? currentSongs!.last.position + 1
                                      : 1,
                                  songId: songs[index].id!,
                                  title: songs[index].title,
                                  videoUrl: songs[index].videoUrl,
                                ),
                              );
                            } else {
                              await trendingSongsNotifier.add(
                                0,
                                TrendingSong(
                                  band: songs[index].band,
                                  priority: 1,
                                  songId: songs[index].id!,
                                  title: songs[index].title,
                                  videoUrl: songs[index].videoUrl,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      );
                    },
                  ),
                ),
                error: (error, _) => Center(
                  child: Text('Error: $error'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ref.invalidate(songsProvider);
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}

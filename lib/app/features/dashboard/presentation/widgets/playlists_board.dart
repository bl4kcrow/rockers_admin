import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/core/widgets/snack_bar.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class PlaylistsBoard extends ConsumerStatefulWidget {
  const PlaylistsBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistBoardState();
}

class _PlaylistBoardState extends ConsumerState<PlaylistsBoard> {
  @override
  Widget build(BuildContext context) {
    final playlistProvider = ref.watch(playlistsProvider);
    final playlistsNotifier = ref.read(playlistsProvider.notifier);

    return playlistProvider.when(
      data: (playlists) {
        return Column(
          children: [
            SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Playlists',
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
                        return CreatePlaylistDialog();
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
                    return ListTile(
                      key: Key('$index'),
                      leading: Text(
                        NumberFormat('00').format(index + 1),
                        style: heading2Style,
                      ),
                      title: Text(playlists[index].name),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: IconButton(
                          onPressed: () async {
                            await playlistsNotifier.removePlaylist(
                              playlists[index].id!,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: AppColors.frenchWine,
                          ),
                        ),
                      ),
                      onTap: () {
                        context.goNamed(
                          'playlistEditing',
                          pathParameters: {'playlistId': playlists[index].id!},
                        );
                      },
                    );
                  },
                  itemCount: playlists.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Playlist item = playlists.removeAt(oldIndex);
                      playlists.insert(
                        newIndex,
                        item,
                      );
                    });
                  },
                ),
              ),
            ),
            BoardFooter(
              onPressedCancel: () {
                ref.invalidate(playlistsProvider);
              },
              onPressedSave: () async {
                await playlistsNotifier.updatePlaylistsPriority();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(text: 'Playlists Sorted Saved'),
                  );
                }
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

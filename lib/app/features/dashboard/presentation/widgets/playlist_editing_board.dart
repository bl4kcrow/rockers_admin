import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/core/widgets/snack_bar.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class PlaylistEditingBoard extends ConsumerStatefulWidget {
  const PlaylistEditingBoard({
    super.key,
    required this.playlistId,
  });

  final String? playlistId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlaylistEditingBoardState();
}

class _PlaylistEditingBoardState extends ConsumerState<PlaylistEditingBoard> {
  late TextEditingController nameTextController;

  bool activePlaylist = false;
  bool enableRanking = false;
  bool isInitialLoad = true;
  bool enableNameTextEditing = false;

  @override
  Widget build(BuildContext context) {
    final playlistData = ref.watch(playlistsProvider).value?.firstWhere(
          (playlist) => playlist.id == widget.playlistId,
        );
    final playlistsNotifier = ref.read(playlistsProvider.notifier);
    final songsData = ref.watch(songsProvider).value;

    if (isInitialLoad == true) {
      activePlaylist = playlistData?.isActive ?? false;
      enableRanking = playlistData?.rankingEnabled ?? false;

      nameTextController = TextEditingController(
        text: playlistData?.name ?? 'N/A',
      );

      playlistData?.songReferences.sort(
        (songA, songB) => songA.position.compareTo(songB.position),
      );

      isInitialLoad = false;
    }

    return Column(
      children: [
        SizedBox(
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameTextController,
                        enabled: enableNameTextEditing,
                        style: heading2Style,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.frenchWine),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.frenchWine),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          enableNameTextEditing = !enableNameTextEditing;
                        });
                      },
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Activate Playlist',
                  ),
                  Switch.adaptive(
                    value: activePlaylist,
                    onChanged: (newValue) {
                      setState(() {
                        activePlaylist = newValue;
                      });
                    },
                  ),
                  const Text(
                    'Enable Ranking',
                  ),
                  Switch.adaptive(
                    value: enableRanking,
                    onChanged: (newValue) {
                      setState(() {
                        enableRanking = newValue;
                      });
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add'),
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: AppColors.eerieBlack.withOpacity(0.5),
                      builder: (context) {
                        return SongToPlaylistDialog(
                          playlist: playlistData,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: (playlistData?.songReferences.isNotEmpty == true)
              ? Card(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      final songData = songsData?.firstWhere(
                        (song) =>
                            song.id ==
                            playlistData.songReferences[index].songId,
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
                              await playlistsNotifier.removeSongFromPlaylist(
                                playlistId: playlistData.id!,
                                songId:
                                    playlistData.songReferences[index].songId,
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
                    itemCount: playlistData!.songReferences.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final SongReference item =
                            playlistData.songReferences.removeAt(oldIndex);
                        playlistData.songReferences.insert(
                          newIndex,
                          item,
                        );
                      });
                    },
                  ),
                )
              : const Center(
                  child: Text('No data found'),
                ),
        ),
        BoardFooter(
          onPressedSave: () async {
            await playlistsNotifier.updatePlaylist(
              playlistData!.copyWith(
                  isActive: activePlaylist,
                  rankingEnabled: enableRanking,
                  name: nameTextController.text.isNotEmpty
                      ? nameTextController.text
                      : 'To Define'),
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(text: 'Playlist Updated'),
              );
            }
          },
          onPressedCancel: () {
            ref.invalidate(playlistsProvider);
          },
        ),
      ],
    );
  }
}

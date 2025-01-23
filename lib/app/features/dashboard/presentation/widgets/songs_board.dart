import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class SongsBoard extends ConsumerWidget {
  const SongsBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSongs = ref.watch(songsProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const _SearchBar(),
          asyncSongs.when(
            data: (songs) => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: PaginatedDataTable(
                    actions: [
                      TextButton.icon(
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add'),
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor:
                              AppColors.eerieBlack.withValues(alpha: 0.5),
                          builder: (context) {
                            return SongAlertDialog();
                          },
                        ),
                      ),
                    ],
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Band',
                          style: heading3Style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Track',
                          style: heading3Style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Video URL',
                          style: heading3Style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Creation Date',
                          style: heading3Style,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: heading3Style,
                        ),
                      ),
                    ],
                    header: const Text(
                      'Songs',
                      style: heading2Style,
                    ),
                    headingRowHeight: 70.0,
                    source: SongsDataTableSource(
                      context: context,
                      ref: ref,
                      songsData: songs,
                    ),
                  ),
                );
              },
            ),
            error: (err, stack) => Text('Error: $err'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class SongsDataTableSource extends DataTableSource {
  SongsDataTableSource({
    required this.context,
    required this.ref,
    required this.songsData,
  });

  final BuildContext context;
  final WidgetRef ref;
  final List<Song> songsData;

  @override
  DataRow? getRow(int index) {
    final song = songsData[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(song.band)),
        DataCell(Text(song.title)),
        DataCell(Text(song.videoUrl)),
        DataCell(
          Text(DateFormat.yMMMMEEEEd().format(song.creationDate)),
        ),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: AppColors.eerieBlack.withValues(alpha: 0.5),
                builder: (context) {
                  return SongAlertDialog(song: song);
                },
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () {
                final songsNotifier = ref.read(songsProvider.notifier);
                songsNotifier.remove(song.id!);
              },
              icon: const Icon(
                Icons.delete_outlined,
                color: AppColors.frenchWine,
              ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => songsData.length;

  @override
  int get selectedRowCount => 0;
}

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final searchController = TextEditingController();

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
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
    );
  }
}

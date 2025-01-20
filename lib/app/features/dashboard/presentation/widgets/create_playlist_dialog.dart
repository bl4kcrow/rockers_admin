import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class CreatePlaylistDialog extends ConsumerWidget {
  CreatePlaylistDialog({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistNotifier = ref.read(playlistsProvider.notifier);

    return AlertDialog(
      title: const Text(
        'Create a New Playlist',
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: nameTextController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState?.validate() == true) {
              await playlistNotifier
                  .add(
                Playlist(
                  isActive: false,
                  name: nameTextController.text,
                  priority:
                      (ref.watch(playlistsProvider).asData?.value.length ?? 0) +
                          1,
                  rankingEnabled: false,
                  songReferences: <SongReference>[],
                  creationDate: DateTime.now().toUtc(),
                  lastUpdate: DateTime.now().toUtc(),
                ),
              )
                  .then(
                (playlistId) {
                  if (context.mounted) {
                    context.pop();
                    context.goNamed(
                      'playlistEditing',
                      pathParameters: {'playlistId': playlistId},
                    );
                  }
                },
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class SongAlertDialog extends ConsumerWidget {
  SongAlertDialog({
    super.key,
    this.song,
  });

  final Song? song;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bandNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsNotifier = ref.read(songsProvider.notifier);

    if (song != null) {
      bandNameController.text = song!.band;
      titleController.text = song!.title;
      videoUrlController.text = song!.videoUrl;
    }

    return AlertDialog(
      title: song == null
          ? const Text('Add New Song')
          : const Text('Update a Song'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: bandNameController,
              decoration: const InputDecoration(hintText: 'Band name'),
              validator: (value) =>
                  value?.isNotEmpty == true ? null : 'Enter a band name',
            ),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
              validator: (value) =>
                  value?.isNotEmpty == true ? null : 'Enter a title',
            ),
            TextFormField(
              controller: videoUrlController,
              decoration: const InputDecoration(hintText: 'Video URL'),
              validator: (value) =>
                  value?.isNotEmpty == true ? null : 'Enter a video URL',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              if (song == null) {
                songsNotifier.add(
                  Song(
                    band: bandNameController.text,
                    title: titleController.text,
                    creationDate: DateTime.now().toUtc(),
                    videoUrl: videoUrlController.text,
                  ),
                );
              } else {
                songsNotifier.updateData(
                  song!.copyWith(
                    band: bandNameController.text,
                    title: titleController.text,
                    videoUrl: videoUrlController.text,
                  ),
                );
              }

              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

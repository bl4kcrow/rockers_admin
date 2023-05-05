import 'package:flutter/material.dart';

class BoardFooter extends StatelessWidget {
  const BoardFooter({
    super.key,
    required this.onPressedSave,
    required this.onPressedCancel,
  });

  final void Function() onPressedSave;
  final void Function() onPressedCancel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
            onPressed: onPressedSave,
          ),
          TextButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel'),
            onPressed: onPressedCancel,
          ),
        ],
      ),
    );
  }
}

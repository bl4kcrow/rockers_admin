import 'dart:ui';

import 'package:window_manager/window_manager.dart';

Future<void> windowInitialization() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(900, 600),
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );
}

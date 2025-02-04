// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:rockers_admin/app/core/constants/environment.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static final Environment _environment = Environment.prod();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: _environment.firebaseApiKey,
    appId: _environment.firebaseAppIdWeb,
    authDomain: 'rockers-db.firebaseapp.com',
    databaseURL: "https://rockers-db.firebaseio.com",
    projectId: 'rockers-db',
    storageBucket: 'rockers-db.appspot.com',
    messagingSenderId: '497715268668',
    measurementId: 'G-9TK284K1F0',
  );

  static final FirebaseOptions windows = FirebaseOptions(
    apiKey: _environment.firebaseApiKey,
    appId: _environment.firebaseAppIdWin,
    authDomain: 'rockers-db.firebaseapp.com',
    databaseURL: "https://rockers-db.firebaseio.com",
    projectId: 'rockers-db',
    storageBucket: 'rockers-db.appspot.com',
    messagingSenderId: '497715268668',
    measurementId: 'G-9TK284K1F0',
  );
}

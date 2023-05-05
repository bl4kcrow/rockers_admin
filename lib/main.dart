import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:rockers_admin/app/core/routes/app_routes.dart';
import 'package:rockers_admin/app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.get('FIREBASE_APIKEY'),
      authDomain: 'rockers-db.firebaseapp.com',
      databaseURL: "https://rockers-db.firebaseio.com",
      projectId: 'rockers-db',
      storageBucket: 'rockers-db.appspot.com',
      messagingSenderId: '497715268668',
      appId: dotenv.get('FIREBASE_APPID'),
      measurementId: 'G-9TK284K1F0',
    ),
  );

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );

  setUrlStrategy(PathUrlStrategy());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      title: 'Rockers Admin',
      routerConfig: appRoutes,
    );
  }
}

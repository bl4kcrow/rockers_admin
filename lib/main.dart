import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:rockers_admin/app/core/constants/environment.dart';
import 'package:rockers_admin/app/core/routes/app_routes.dart';
import 'package:rockers_admin/app/core/theme/app_theme.dart';
import 'package:rockers_admin/app/core/utils/utils.dart';
import 'package:rockers_admin/app/firebase_options_prod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows) {
    await windowInitialization();
  }
  
  await dotenv.load(fileName: ".env");
  final Environment environment = Environment.prod();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance
      .signInWithEmailAndPassword(
        email: environment.adminEmail,
        password: environment.adminPassword,
      )
      .then((_) => debugPrint('Login succesfull'))
      .onError((error, __) => debugPrint('Login error: $error'));

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );

  usePathUrlStrategy();
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

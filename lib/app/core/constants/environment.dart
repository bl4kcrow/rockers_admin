import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  const Environment._({
    required this.firebaseApiKey,
    required this.firebaseAppIdWeb,
    required this.firebaseAppIdWin,
    required this.adminEmail,
    required this.adminPassword,
  });

  final String firebaseApiKey;
  final String firebaseAppIdWeb;
  final String firebaseAppIdWin;
  final String adminEmail;
  final String adminPassword;

  factory Environment.dev() => Environment._(
        firebaseApiKey: dotenv.get('FIREBASE_APIKEY_DEV'),
        firebaseAppIdWeb: dotenv.get('FIREBASE_APPID_WEB_DEV'),
        firebaseAppIdWin: dotenv.get('FIREBASE_APPID_WIN_DEV'),
        adminEmail: dotenv.get('ADMIN_EMAIL_DEV'),
        adminPassword: dotenv.get('ADMIN_PASSWORD_DEV'),
      );

  factory Environment.prod() => Environment._(
        firebaseApiKey: dotenv.get('FIREBASE_APIKEY_PROD'),
        firebaseAppIdWeb: dotenv.get('FIREBASE_APPID_WEB_PROD'),
        firebaseAppIdWin: dotenv.get('FIREBASE_APPID_WIN_PROD'),
        adminEmail: dotenv.get('ADMIN_EMAIL_PROD'),
        adminPassword: dotenv.get('ADMIN_PASSWORD_PROD'),
      );
}

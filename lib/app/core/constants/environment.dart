import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final String firebaseApiKey = dotenv.get('FIREBASE_APIKEY');
  static final String firebaseAppId = dotenv.get('FIREBASE_APPID');
  static final String adminEmail = dotenv.get('ADMIN_EMAIL');
  static final String adminPassword = dotenv.get('ADMIN_PASSWORD');
}

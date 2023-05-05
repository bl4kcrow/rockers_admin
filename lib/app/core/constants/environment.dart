import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final String firebaseApiKey = dotenv.get('FIREBASE_APIKEY');
  static final String firebaseAppId = dotenv.get('FIREBASE_APPID');
}

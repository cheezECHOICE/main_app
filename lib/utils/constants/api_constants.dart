import 'package:flutter_dotenv/flutter_dotenv.dart';

String? tSecretAPIKey = dotenv.env['SECRET_API_KEY'];
String dbLink = dotenv.env['DB_LINK'] ?? '';
String MAP_API = dotenv.env['MAP_API_KEY'] ?? '';
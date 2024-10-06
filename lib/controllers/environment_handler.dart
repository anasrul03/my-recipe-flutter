import 'package:flutter_dotenv/flutter_dotenv.dart';



  String get apiUrl => dotenv.env['URL'] ?? "";
  String get apiKey => dotenv.env['SERVICE_ROLE_KEY'] ?? "";


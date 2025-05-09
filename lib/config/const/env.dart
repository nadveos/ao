import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String baseUrl = dotenv.env['API_URL'] ?? 'Wrong Base Url';
  static String email = dotenv.env['ADMIN_EMAIL'] ?? 'Wrong Email';
  static String password = dotenv.env['ADMIN_PASS'] ?? 'Wrong Password';
}

// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Login {
  static list(String email, String password) async {
    String url = dotenv.env['BASE_URL'] + "/manifest/login";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "email": email,
      "password": password,
    });
    var res = jsonDecode(response.body);

    if (res['status'] == 400) {
      return res['status'];
    } else {
      return jsonDecode(response.body)['manifest'];
    }
  }
}

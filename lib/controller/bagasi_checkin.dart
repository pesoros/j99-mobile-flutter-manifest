// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BagasiCheckin {
  static list(String ticketNumber) async {
    String url = dotenv.env['BASE_URL'] + "/manifest/bagagge/set";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "ticketNumber": ticketNumber,
      "status": "1",
    });

    return jsonDecode(response.body);
  }
}

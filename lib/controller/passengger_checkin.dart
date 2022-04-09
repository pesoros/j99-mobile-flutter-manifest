// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PassenggerCheckin {
  static list(String ticketNumber, String status) async {
    String url = dotenv.env['BASE_URL'] + "/manifest/checkin/set";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "ticketNumber": ticketNumber,
      "status": status,
    });

    return jsonDecode(response.body);
  }
}

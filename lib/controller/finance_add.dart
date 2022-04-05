import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:j99_mobile_manifest_flutter/utils/variables.dart' as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddFinance {
  static list(String description, String nominal, String action) async {
    String url = dotenv.env['BASE_URL'] + "/manifest/expenses/set";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "tripIdNo": variable.trip_id_no,
      "tripDate": variable.trip_date,
      "description": description,
      "nominal": nominal,
      "action": action,
    });
    return jsonDecode(response.body);
  }
}

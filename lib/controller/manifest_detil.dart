// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:j99_mobile_manifest_flutter/utils/variables.dart' as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ManifestDetail {
  static list() async {
    String url = dotenv.env['BASE_URL'] + "/manifest/trip";

    Uri parseUrl = Uri.parse(
      url,
    );

    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "tripIdNo": variable.trip_id_no,
      "tripDate": variable.trip_date,
    });
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return jsonDecode(response.body)['status'];
    }
  }
}

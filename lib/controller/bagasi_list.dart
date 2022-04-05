import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:j99_mobile_manifest_flutter/model/bagasi_model.dart';
import 'package:j99_mobile_manifest_flutter/utils/variables.dart' as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BagasiList {
  static list() async {
    String url = dotenv.env['BASE_URL'] + "/manifest/baggage/list";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      // "tripIdNo": "1",
      // "tripDate": "2022-03-31",
      "tripIdNo": variable.trip_id_no,
      "tripDate": variable.trip_date,
    });

    List<BagasiModel> list = [];

    for (var data in jsonDecode(response.body)['data'] as List) {
      list.add(BagasiModel.fromJson(data));
    }

    return list;
  }
}

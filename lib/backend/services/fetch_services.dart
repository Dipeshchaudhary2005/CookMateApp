import 'dart:convert';

import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FetchServices {
  static Future<List<Map<String, List<String>>>?> getCuisines(
    BuildContext context,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/fetch/cuisines',
      );
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
      );
      if (response.statusCode.toString().contains('20')) {
        final json = jsonDecode(response.body);
        final output = (json['cuisines'] as List)
            .map((e) => {e['name'] as String: e['dishes'] as List<String>})
            .toList();
        return output;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return null;
    }
  }
}

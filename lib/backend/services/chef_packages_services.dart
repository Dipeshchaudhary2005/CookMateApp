import 'dart:convert';

import 'package:cookmate/backend/model/ChefPackage.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChefPackagesServices {
  static Future<List<ChefPackage>?> getChefsPackages(
    BuildContext context,
    String chefId,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/packages/chef/$chefId',
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
        if (json['packages'] == null) return null;
        final packages = (json['packages'] as List)
            .map((e) => ChefPackage.fromJSON(e))
            .toList();
        return packages;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return null;
    }
  }

  static Future<ChefPackage?> createPackage(
    BuildContext context,
    String name,
    String description,
    num price,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/packages/',
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );
      if (response.statusCode.toString().contains('20')) {
        final data = jsonDecode(response.body);
        final package = ChefPackage.fromJSON(data['package']);
        return package;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return null;
    }
  }

  static Future<bool> updatePackage(
    BuildContext context,
    String id, {
    String? name,
    String? description,
    num? price,
    List<String>? dishes,
  }) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/packages/$id',
      );
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'dishes': dishes,
        }),
      );
      if (response.statusCode.toString().contains('20')) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<bool> deletePackage(BuildContext context, String id) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/packages/$id',
      );
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
      );
      if (response.statusCode.toString().contains('20')) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cookmate/backend/model/chefpost.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PostServices {
  static Future<ChefPost?> createPost(
    BuildContext context,
    File image,
    String title,
    String description,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/posts/',
      );
      final request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': StaticClass.jsonWebToken!,
      });
      request.fields.addAll({'title': title, 'description': description});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();
      if (response.statusCode.toString().contains("20")) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        final post = ChefPost.fromJSON(data['post']);
        return post;
      } else {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating post: ${e.toString()}");
      }
      if (context.mounted) {
        Helper.showError(context, "Internal error");
      }
      return null;
    }
  }

  static Future<List<ChefPost>?> getPostOfChef(
    BuildContext context,
    String chefId,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}/posts/chef/$chefId',
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
        if (json['posts'] == null) return null;
        final posts = (json['posts'] as List)
            .map((e) => ChefPost.fromJSON(e))
            .toList();
        return posts;
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
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_hive/constants/api_constants.dart';
import 'package:job_hive/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAPIServices {
  static final prefs = SharedPreferences.getInstance();
  // get users details
  static Future<void> getUser(String token, BuildContext context) async {
    try {
      final url = Uri.parse(getUserData);
      final response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .setUser(jsonDecode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }

  // update user details
  static Future<String> updateUser(
    Map<String, dynamic> data,
    BuildContext context,
  ) async {
    String res = 'something went wrong';
    final token = await prefs.then((value) => value.getString('token'));
    try {
      final url = Uri.parse(updateUserAPI);
      final response = await http.patch(url,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonDecode(response.body));
        }
        return res = 'success';
      }
    } catch (e) {
      if (context.mounted) {
        res = 'unable to update user, try again later';
      }
    }
    return res;
  }

  // delete user details
  static Future<String> deleteUserDetails(
      String toDelete, BuildContext context, String id, String name) async {
    final token = await prefs.then((value) => value.getString('token'));
    String res = 'something went wrong';
    if (toDelete == 'project' ||
        toDelete == 'achievement' ||
        toDelete == 'experience' ||
        toDelete == 'education') {
      try {
        final url = Uri.parse(deleteUserAPI);
        final body = {
          toDelete: {
            '_id': id,
          }
        };
        final response = await http.delete(url,
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body));

        if (response.statusCode == 200 && context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonDecode(response.body));
        }
        return res = 'success';
      } catch (e) {
        res = 'unable to delete $toDelete, try again later';
      }
    } else {
      try {
        final url = Uri.parse(deleteUserAPI);
        final body = {
          toDelete: name,
        };
        final response = await http.delete(url,
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body));

        if (response.statusCode == 200 && context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonDecode(response.body));
        }
        return res = 'success';
      } catch (e) {
        res = 'unable to delete $toDelete, try again later';
      }
    }
    return res;
  }

  // find user by id
  static Future<Map<String, dynamic>> findUserById(String id) async {
    try {
      final url = Uri.parse('$findUsersByIdAPI/$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to find user');
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_hive/constants/api_constants.dart';
import 'package:job_hive/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  // register using email and password
  static Future<String> registerUser(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    String res = 'something went wrong';
    try {
      final url = Uri.parse(registerUserAPI);

      final body = {
        'name': name,
        'email': email,
        'password': password,
      };

      final response = await http.post(url,
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        if (context.mounted) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', jsonDecode(response.body)['token']);
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(jsonDecode(response.body)['user']);
          }
        }
        return res = 'success';
      }
    } catch (e) {
      if (context.mounted) {
        res = 'unable to register user, try again later';
      }
    }

    return res;
  }

  // login using email and password
  static Future<String> loginUser(
      String email, String password, BuildContext context) async {
    String res = 'something went wrong';
    try {
      final url = Uri.parse(loginUserAPI);

      final body = {
        "email": email,
        "password": password,
      };

      final response = await http.post(url,
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        if (context.mounted) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', jsonDecode(response.body)['token']);
          if (context.mounted) {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(jsonDecode(response.body)['user']);
          }

          return res = 'success';
        }
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        res = 'unable to login user, try again later';
      }
    }

    return res;
  }

  // logout user
  static void logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (context.mounted) {
      Provider.of<UserProvider>(context, listen: false).setUser({});
    }
  }
}

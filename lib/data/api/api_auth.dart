import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuth {
  static const String _baseUrl = "http://192.168.92.227:8000/api";
  final String stateKey = "state";
  final String tokenKey = "token";
  final String roleKey = "role";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(stateKey) ?? false;
  }

  Future<dynamic> login(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final roles = data["loginResult"]["roles"];
      final role = roles is List ? roles.first : roles.toString();

      await preferences.setString(tokenKey, data["loginResult"]["token"]);
      await preferences.setBool(stateKey, true);
      await preferences.setString(roleKey, role);
      return true;
    } else {
      return data["message"];
    }
  }

   Future<dynamic> register(String nama, String gender, String id_kelas, String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/register"),
      headers: {"Content-Type": "application/json", "Accept": "application/json",},
      body: jsonEncode({"nama": nama, "gender": gender, "id_kelas": id_kelas, "email": email, "password": password}),
    );
    
    print("Response body register: ${response.body}");
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return data["message"];
    }
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/logout"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${preferences.getString(tokenKey)}",
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await preferences.setString(tokenKey, "");
      await preferences.setString(roleKey, "");
      return preferences.setBool(stateKey, false);
    } else {
      return data["message"];
    }
  }
}

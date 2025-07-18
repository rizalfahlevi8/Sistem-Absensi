import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiPresensi {
  static const String _baseUrl = "http://192.168.92.227:8000/api";

  Future<Map<String, String>> isCheck() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString('token');

    final response = await http.get(
      Uri.parse("$_baseUrl/presensi/check"),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return{
        'next': data["jenis"],
        'batas_jam': data["batas_jam"],
      };
    } else {
      throw Exception('Failed to check presensi');
    }
  }

  Future<Map<String, String>> createPresensi(
    String latitude,
    String longitude,
  ) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString('token');

    final response = await http.post(
      Uri.parse("$_baseUrl/presensi/store"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {
        'message': data["message"],
        'next': data["data"]["next"],
        'batas_jam': data["data"]["batas_jam"],
      };
    } else {
      throw Exception(data["message"] ?? "Terjadi kesalahan");
    }
  }
}

import 'dart:convert';

import 'package:presensi/data/model/siswa_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiSiswa {
  static const String _baseUrl = "http://192.168.92.227:8000/api";

  Future<SiswaListResponse> index([int page = 1, int size = 10]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$_baseUrl/siswa?page=$page&size=$size"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print("$_baseUrl/siswa?page=$page&size=$size");
    print("Response status siswa: ${response.body}");
    if (response.statusCode == 200) {
      return SiswaListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load story list");
    }
  }
}

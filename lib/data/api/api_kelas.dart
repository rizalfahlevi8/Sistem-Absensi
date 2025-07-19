import 'dart:convert';

import 'package:presensi/data/model/kelas_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiKelas {
  static const String _baseUrl = "http://192.168.92.227:8000/api";

  Future<KelasListResponse> index() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/kelas"),
      headers: {'Accept': 'application/json'},
    );

    print("Response status kelas: ${response.body}");
    if (response.statusCode == 200) {
      return KelasListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load story list");
    }
  }

  Future<dynamic> store(String nama, String jurusan) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final response = await http.post(
      Uri.parse("$_baseUrl/kelas/store"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json", // <- WAJIB ditambahkan
      },
      body: jsonEncode({"nama": nama, "jurusan": jurusan}),
    );

    print("Response body: ${response.body}");
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return data["message"];
    }
  }
}

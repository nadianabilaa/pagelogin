import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000"; // Ganti dengan URL backend-mu

  // ✅ Fungsi Registrasi (Terhubung dengan SignUpScreen)
  static Future<Map<String, dynamic>> register(String fullname, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"msg": "Registrasi gagal: ${response.body}"};
      }
    } catch (e) {
      return {"msg": "Terjadi kesalahan: $e"};
    }
  }

  // ✅ Fungsi Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data["token"]); // Simpan token setelah login sukses
        return data;
      } else {
        return {"msg": "Login gagal: ${response.body}"};
      }
    } catch (e) {
      return {"msg": "Terjadi kesalahan: $e"};
    }
  }

  // ✅ Simpan Token ke SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // ✅ Ambil Token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ Fungsi Logout (Hapus Token)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ✅ Fungsi Get Profile (Autentikasi dengan Token)
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return {"msg": "Token tidak ditemukan, harap login kembali"};
      }

      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"msg": "Gagal mengambil profil: ${response.body}"};
      }
    } catch (e) {
      return {"msg": "Terjadi kesalahan: $e"};
    }
  }
}

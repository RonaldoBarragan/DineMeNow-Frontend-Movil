import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  static const String apiUrl =
      //"http://10.0.2.2:8080/api/auth/login";
      "http://127.0.0.1:8080/api/auth/login";

  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        //"user": correo,
        "correo": correo,
        //"pass": password,
        "password": password,
      }),
    );

    final json =
        jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return json;
    }

    throw Exception(
      json["mensaje"] ??
      json["error"] ??
      json["message"] ??
      "Error en login",
    );
  }
}
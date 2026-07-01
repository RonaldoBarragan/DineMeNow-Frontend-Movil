import 'dart:convert';
import 'package:http/http.dart' as http;

class MesaService {
  static const String apiUrl = "http://127.0.0.1:8080/api/mesas";

  /// Trae las mesas de un restaurante.
  /// Ruta real: GET /api/mesas/restaurante/{nitRestaurante}
  static Future<List<dynamic>> listarPorRestaurante(
    String nitRestaurante, {
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse("$apiUrl/restaurante/$nitRestaurante"),
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      return [];
    }

    throw Exception("Error ${response.statusCode}: ${response.body}");
  }
}
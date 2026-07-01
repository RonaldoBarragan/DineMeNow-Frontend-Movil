import 'dart:convert';
import 'package:http/http.dart' as http;

class RestauranteService {
  static const String apiUrl = "http://127.0.0.1:8080/api/restaurantes";

  /// Trae la lista de restaurantes disponibles.
  /// [token] es opcional: pásalo si el endpoint requiere estar logueado.
  Future<List<dynamic>> obtenerRestaurantes({String? token}) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);

      // Caso normal: el backend devuelve directamente un array
      if (decoded is List) return decoded;

      // Caso alternativo: el backend envuelve la lista, ej: {"data": [...]}
      if (decoded is Map && decoded["data"] is List) {
        return decoded["data"];
      }

      return [];
    }

    throw Exception("Error ${response.statusCode}: ${response.body}");
  }

  /// Trae el detalle de UN restaurante por su NIT.
  /// Ruta real confirmada: GET /api/restaurantes/nit/{nit}
  Future<Map<String, dynamic>> obtenerRestaurantePorNit(
    String nit, {
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse("$apiUrl/nit/$nit"),
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception("Formato de respuesta inesperado para el restaurante");
    }

    throw Exception("Error ${response.statusCode}: ${response.body}");
  }
}
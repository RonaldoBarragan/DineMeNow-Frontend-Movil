import 'dart:convert';
import 'package:http/http.dart' as http;

class VerificacionService {
  final String apiUrl = "http://127.0.0.1:8080/api/verificacion";

  // CONFIRMAR CODIGO
  Future<Map<String, dynamic>> confirmarCodigo(
    String correo,
    String codigo,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/confirmar"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({"correo": correo, "codigo": codigo}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data["error"] ?? "Error al verificar");
      }

      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // REENVIAR CODIGO
  Future<Map<String, dynamic>> reenviarCodigo(String correo) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/enviar"),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({"correo": correo}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("No se pudo reenviar el código");
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ClienteService {
  // Ajusta a 10.0.2.2 si estás en emulador de Android
  static const String _baseUrl = "http://127.0.0.1:8080/api/clientes";

  Future<List<dynamic>> obtenerAllClientes() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Tu controlador devuelve una ResponseEntity<List<ClienteDto>>, así que esto mapea perfecto
        return json.decode(response.body);
      } else {
        throw Exception("Error al obtener clientes: ${response.statusCode}");
      }
    } catch (error) {
      print("Error en la petición: $error");
      rethrow;
    }
  }
}

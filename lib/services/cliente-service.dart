import 'dart:convert';
import 'package:http/http.dart' as http;

class ClienteService {
  static const String apiUrl = "http://127.0.0.1:8080/api/clientes";

  static Future<Map<String, dynamic>> registrarCliente({
    required String nombre,
    required String apellido,

    required String tipoDocumento,
    required String numeroDocumento,

    required String calle,
    required String numeroCalle,
    required String ciudad,
    required String codigoPostal,
    required String pais,

    required String correo,
    required String telefono,

    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$apiUrl/registro"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "nombre": nombre,

        "apellido": apellido,

        "documento": {"tipo": tipoDocumento, "numero": numeroDocumento},

        "direccion": {
          "calle": calle,

          "numero": numeroCalle,

          "ciudad": ciudad,

          "codigoPostal": codigoPostal,

          "pais": pais,
        },

        "correo": correo,

        "telefono": telefono,

        "foto": "",

        // ojo:
        // en tu API pide user separado
        "user": correo,

        "password": password,
      }),
    );
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    // Manejar errores del backend

    String mensaje = "Error al registrar cliente";

    // Caso correo ya registrado u otros errores directos
    if (json["error"] != null) {
      mensaje = json["error"];
    }
    // Caso errores por campos
    else if (json["errors"] != null) {
      final errors = json["errors"];

      if (errors["correo"] != null) {
        mensaje = errors["correo"];
      } else if (errors["documento.numero"] != null) {
        mensaje = errors["documento.numero"];
      }
    }

    throw Exception(mensaje);
  }
}

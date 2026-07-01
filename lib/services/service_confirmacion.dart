import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservaService {
  // 1. Debe ser STATIC para que se pueda llamar como ReservaService.crearReserva(...)
  static Future<void> crearReserva({
    required String token,
    required String nitRestaurante,
    required List<String> nombrePlatos,
    required String numeroMesa,
    required DateTime fecha,
    required String hora,
    required String descripcion,
  }) async {
    
    // 2. Apuntar a la ruta exacta configurada en tu @PostMapping
    final url = Uri.parse('http://127.0.0.1:8080/api/reservas/CrearReservas');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Si manejas Spring Security con JWT
        },
        body: jsonEncode({
          'nitRestaurante': nitRestaurante,
          'nombrePlatos': nombrePlatos,
          'numeroMesa': numeroMesa,
          // Formatea la fecha como lo espere tu ReservaDto (ej: yyyy-MM-dd)
          'fecha': "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
          'hora': hora,
          'descripcion': descripcion,
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Error al crear la reserva en el servidor: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
    // NUEVO

  static Future<List<dynamic>> obtenerMisReservas({
    required String token,
  }) async {


    final url = Uri.parse('http://127.0.0.1:8080/api/reservas/mis-reservas');



    final response = await http.get(
      url,
      headers: {
        'Authorization':'Bearer $token',
        'Content-Type':'application/json',
      },
    );


    if(response.statusCode == 200){

      return jsonDecode(response.body);

    }


    throw Exception(
      "Error cargando reservas ${response.body}"
    );

  }
}
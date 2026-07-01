import 'dart:convert';

import 'package:dinemenow/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DetalleReservaScreen extends StatelessWidget {
  final Map<String, dynamic> reserva; // Recibe los datos de la reserva seleccionada

  const DetalleReservaScreen({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    // Extracción segura de variables desde el mapa 'reserva'
    final restaurante = reserva["restaurante"] ?? {};
    final nombreRestaurante = restaurante["nombre"] ?? "Restaurante";
    final fotoUrl = restaurante["foto"] ?? "";
    final estado = reserva["estado"] ?? "Pendiente";
    final fecha = reserva["fecha"] ?? "";
    final hora = reserva["hora"] ?? "";
    final numeroMesa = reserva["numeroMesa"] ?? "";
    final descripcion = reserva["descripcion"] ?? "Sin observaciones adicionales";
    
    // Obtenemos los platos (si viene nulo, creamos una lista vacía)
    final List<dynamic> platos = reserva["nombrePlatos"] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SECCIÓN DE CABECERA CON IMAGEN DE FONDO ---
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(fotoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Degradado oscuro para que se lea bien el nombre del restaurante encima de la foto
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Botón para volver atrás
                Positioned(
                  top: 45,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Información encimada en la imagen
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreRestaurante,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Badge del Estado
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9), // Fondo verde suave
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          estado,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32), // Texto verde oscuro
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 2. TARJETA: DETALLES DE LA RESERVA ---
                  _buildSectionTitle("DETALLES DE LA RESERVA"),
                  const SizedBox(height: 8),
                  _buildContainerCard(
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.calendar_today_outlined, "Fecha", fecha),
                        const Divider(height: 20),
                        _buildDetailRow(Icons.access_time_outlined, "Hora", hora),
                        const Divider(height: 20),
                        _buildDetailRow(Icons.table_restaurant_outlined, "Mesa asignada", "Mesa #$numeroMesa"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 3. TARJETA: PLATILLOS SELECCIONADOS ---
                  _buildSectionTitle("PLATILLOS SELECCIONADOS"),
                  const SizedBox(height: 8),
                  _buildContainerCard(
                    child: platos.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "No se pre-ordenaron platos para esta reserva.",
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: platos.map((platoId) {
                              // DICCIONARIO CON TUS DATOS REALES DE MONGODB
                              final Map<String, String> nombresDePlatos = {
                                "6a4564ae6ed6fd3f8c97a4f2": "Arepas con Queso",
                                "6a45656902f01d8b5331ce72": "Bandeja Paisa Tradicional",
                                "6a45655a16ed6fd3f8c97a4f3": "Postre de Tres Leches",
                                "6a4565b36ed6fd3f8c97a4f4": "Jugo Natural Mango",
                              };

                              // Busca el ID convertido a string; si no existe, conserva el ID original por seguridad
                              final nombreLegible = nombresDePlatos[platoId.toString()] ?? platoId.toString();

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.restaurant_menu, size: 16, color: Colors.deepOrange),
                                    const SizedBox(width: 10),
                                    Text(
                                      nombreLegible,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // --- 4. TARJETA: OBSERVACIONES ---
                  _buildSectionTitle("OBSERVACIONES"),
                  const SizedBox(height: 8),
                  _buildContainerCard(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        descripcion,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // --- 5. BOTÓN CANCELAR RESERVA ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        // 1. Desplegamos el Popup de Confirmación interactivo
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color(0xFFEF5350),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "¿Cancelar Reserva?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                "¿Estás seguro de que deseas cancelar esta reserva? Esta acción no se puede deshacer.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                    dialogContext,
                                  ), // Cierra solo el Popup
                                  child: const Text(
                                    "No, regresar",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF5350),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Cerramos el Popup para iniciar la petición HTTP
                                    Navigator.pop(dialogContext);

                                    // 2. Clonamos el DTO de la reserva y alteramos el estado a Cancelada
                                    Map<String, dynamic> dtoActualizado =
                                        Map<String, dynamic>.from(reserva);
                                    dtoActualizado['estado'] = "Cancelada";

                                    // Obtén aquí tu token JWT de donde lo tengas guardado (ej. tu AuthProvider o SharedPreferences)
                                    final token = context
                                        .read<AuthProvider>()
                                        .user
                                        ?.token;

                                    try {
                                      final String idReserva =
                                          reserva["id"] ?? reserva["_id"];

                                      // 3. Despachamos la actualización masiva incluyendo el Header de Autorización
                                      final response = await http.put(
                                        Uri.parse(
                                          "http://127.0.0.1:8080/api/reservas/actuReserva/$idReserva",
                                        ),
                                        headers: {
                                          "Content-Type": "application/json",
                                          // IMPORTANTE: Descomenta esta línea y pásale tu JWT real para quitar el 403
                                          "Authorization": "Bearer $token",
                                        },
                                        body: jsonEncode(dtoActualizado),
                                      );

                                      if (response.statusCode == 200) {
                                        // 4. Éxito: Volvemos a la vista de Mis Reservas mandando el ID para mover la pestaña
                                        if (context.mounted) {
                                          Navigator.pop(context, true);
                                        }
                                      } else if (response.statusCode == 403) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Error 403: No autorizado. Verifica que el Token JWT sea enviado.",
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error en servidor: Código ${response.statusCode}",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Error de conexión: $e",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Sí, cancelar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFEF5350),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancelar Reserva",
                        style: TextStyle(
                          color: Color(0xFFEF5350),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget para títulos de sección estilizados
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        letterSpacing: 0.5,
      ),
    );
  }

  // Helper widget para contenedores redondeados limpios (Cards del prototipo)
  Widget _buildContainerCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Helper widget para construir las filas de detalles con iconos precisos
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepOrange.withOpacity(0.8)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}
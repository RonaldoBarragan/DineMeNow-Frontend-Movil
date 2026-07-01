import 'package:dinemenow/detalles_reserva.dart';
import 'package:dinemenow/services/service_confirmacion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinemenow/providers/auth_provider.dart';
import 'package:dinemenow/services/reserva_service.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({super.key});

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  List<dynamic> reservas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarReservas();
  }

 Future<void> cargarReservas() async {
    final token = context.read<AuthProvider>().user?.token;

    if (token == null) return;

    setState(() {
      loading = true;
    });

    try {
      final data = await ReservaService.obtenerMisReservas(token: token);

      // Quitar reservas canceladas
      final reservasActivas = data.where((r) {
        final estado = r["estado"]?.toString().toLowerCase() ?? "";

        return estado != "cancelada";
      }).toList();

      if (!mounted) return;

      setState(() {
        reservas = reservasActivas;

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar reservas: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Un fondo gris claro premium para que resalten las tarjetas blancas
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mis Reservas",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepOrange,
                        ),
                      )
                    : reservas.isEmpty
                    ? const Center(
                        child: Text("No tienes reservas actualmente"),
                      )
                    : ListView.builder(
                        itemCount: reservas.length,
                        itemBuilder: (context, index) {
                          final r = reservas[index];
                          final nombreRestaurante =
                              r["restaurante"]?["nombre"] ?? "Restaurante";
                          final fotoUrl = r["restaurante"]?["foto"] ?? "";
                          final estado = r["estado"] ?? "Pendiente";

                          // Formateo o extracción básica de variables de tu JSON
                          final fecha = r["fecha"] ?? "";
                          final hora = r["hora"] ?? "";
                          final mesa = r["numeroMesa"] ?? "";

                          return GestureDetector(
                            onTap: () async {
                              final resultado = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleReservaScreen(reserva: r),
                                ),
                              );

                              // Si volvió después de cancelar
                              if (resultado == true) {
                                cargarReservas();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // --- 1. SECCIÓN DE LA IMAGEN ---
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      fotoUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      // Solución al ImageCodecException: Si falla o está vacía, muestra un placeholder elegante
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.deepOrange
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                Icons.restaurant,
                                                color: Colors.deepOrange,
                                                size: 30,
                                              ),
                                            );
                                          },
                                    ),
                                  ),

                                  // --- 2. SECCIÓN DEL CONTENIDO (DETALLES) ---
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Fila superior: Nombre del restaurante y Estado estilizado
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  nombreRestaurante,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              // Badge o Etiqueta de Estado Premium
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      estado.toLowerCase() ==
                                                              "próxima" ||
                                                          estado.toLowerCase() ==
                                                              "pendiente"
                                                      ? const Color(
                                                          0xFFE8F5E9,
                                                        ) // Verde suave
                                                      : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  estado,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        estado.toLowerCase() ==
                                                                "próxima" ||
                                                            estado.toLowerCase() ==
                                                                "pendiente"
                                                        ? const Color(
                                                            0xFF2E7D32,
                                                          ) // Verde oscuro
                                                        : Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          // Fila de los metadatos (Fecha, Hora, Mesa) con iconos minimalistas
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                fecha,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                hora,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.table_restaurant,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "Mesa: $mesa",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Flechita indicadora a la derecha
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

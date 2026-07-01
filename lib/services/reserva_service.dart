import 'package:dinemenow/cliente_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinemenow/services/restaurante_service.dart';
import 'package:dinemenow/services/platos_service.dart';
import 'package:dinemenow/services/mesa_service.dart';
import 'package:dinemenow/services/service_confirmacion.dart';
import 'package:dinemenow/providers/auth_provider.dart';


class RestauranteDetalle extends StatefulWidget {
  final String nit;
  final String? nombrePreview;

  const RestauranteDetalle({
    super.key,
    required this.nit,
    this.nombrePreview,
  });

  @override
  State<RestauranteDetalle> createState() => _RestauranteDetalleState();
}

class _RestauranteDetalleState extends State<RestauranteDetalle> {
  Map<String, dynamic>? _restaurante;
  List<dynamic> _platos = [];
  List<dynamic> _mesas = [];
  
  bool _isLoading = true;
  String _errorMessage = '';

  // Me aseguré de cambiar esto para almacenar el ID o mapa único del plato, 
  // pero si tu servicio usa nombres estrictamente, puedes mantener el String del ID.
  final Set<String> _platosSeleccionados = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarTodo());
  }

  Future<void> _cargarTodo() async {
    final token = context.read<AuthProvider>().user?.token;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final resultados = await Future.wait([
        RestauranteService().obtenerRestaurantePorNit(widget.nit, token: token),
        PlatosService.listarPorRestaurante(widget.nit, token: token),
        MesaService.listarPorRestaurante(widget.nit, token: token),
      ]);

      if (!mounted) return;
      setState(() {
        _restaurante = resultados[0] as Map<String, dynamic>;
        _platos = resultados[1] as List<dynamic>;
        _mesas = resultados[2] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo cargar el restaurante.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _buildContenido(),
      ),
      bottomNavigationBar: _isLoading || _errorMessage.isNotEmpty
          ? null
          : _buildBotonReservar(),
    );
  }

  Widget _buildContenido() {
    final r = _restaurante!;
    final nombre = r['nombre']?.toString() ?? widget.nombrePreview ?? 'Restaurante';
    final categoria = r['categoria']?.toString() ?? '';
    final descripcion = r['descripcion']?.toString() ?? '';
    final foto = r['foto']?.toString() ?? '';
    final telefono = r['telefono']?.toString() ?? '';

    final direccionRaw = r['direccion'];
    final direccion = direccionRaw is Map
        ? [
            direccionRaw['calle'],
            direccionRaw['numero'],
            direccionRaw['ciudad'],
          ].where((e) => e != null && e.toString().trim().isNotEmpty).join(' ')
        : '';

    final apertura = r['horarioApertura']?.toString() ?? '';
    final cierre = r['horarioCierre']?.toString() ?? '';
    final dias = (r['diasAbierto'] as List?)?.map((d) => d.toString()).toList() ?? [];
    final servicios = (r['servicios'] as List?)?.map((s) => s.toString()).toList() ?? [];

    final platosDisponibles = _platos.where((p) => p['disponible'] == true).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── FOTO + BOTÓN VOLVER ─────────────────────────────
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: foto.isNotEmpty
                    ? Image.network(foto, fit: BoxFit.cover)
                    : const Icon(Icons.restaurant, size: 60, color: Colors.white),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                if (categoria.isNotEmpty)
                  Text(categoria, style: TextStyle(color: Colors.grey[600])),

                if (descripcion.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(descripcion, style: const TextStyle(fontSize: 14)),
                ],

                const SizedBox(height: 12),

                if (direccion.isNotEmpty)
                  _InfoRow(icono: Icons.location_on, texto: direccion),
                if (telefono.isNotEmpty)
                  _InfoRow(icono: Icons.phone, texto: telefono),

                if (apertura.isNotEmpty && cierre.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Horario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('$apertura - $cierre'),
                  if (dias.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(dias.join(', '), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ],

                if (servicios.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Servicios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: servicios
                        .map((s) => Chip(
                              label: Text(s, style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.orange.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),
                const Text('Menú', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text(
                  'Selecciona los platos que quieres reservar (opcional)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),

                if (platosDisponibles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text('Este restaurante no tiene platos disponibles ahora.',
                        style: TextStyle(color: Colors.grey[600])),
                  )
                else
                  ...platosDisponibles.map((p) {
                    final nombrePlato = p['nomPlato']?.toString() ?? '';
                    // Usamos el id del plato de MongoDB como referencia única (p['_id'] o p['id'])
                    final idPlato = p['_id']?.toString() ?? p['id']?.toString() ?? nombrePlato;

                    return _PlatoTile(
                      nombre: nombrePlato,
                      descripcion: p['descripcion']?.toString() ?? '',
                      precio: p['precio']?.toString() ?? '',
                      seleccionado: _platosSeleccionados.contains(idPlato),
                      onTap: () {
                        setState(() {
                          if (_platosSeleccionados.contains(idPlato)) {
                            _platosSeleccionados.remove(idPlato);
                          } else {
                            _platosSeleccionados.add(idPlato);
                          }
                        });
                      },
                    );
                  }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonReservar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _mesas.isEmpty ? null : _abrirModalReserva,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              _mesas.isEmpty ? "Sin mesas registradas" : "Reservar Mesa",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _abrirModalReserva() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ModalReserva(
        nitRestaurante: widget.nit,
        nombrePlatos: _platosSeleccionados.toList(), // Pasa la lista de IDs seleccionados
        mesas: _mesas,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _InfoRow({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icono, size: 16, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(child: Text(texto, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _PlatoTile extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String precio;
  final bool seleccionado;
  final VoidCallback onTap;

  const _PlatoTile({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: seleccionado ? Colors.orange.withOpacity(0.08) : Colors.white,
          border: Border.all(color: seleccionado ? Colors.deepOrange : Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              seleccionado ? Icons.check_circle : Icons.circle_outlined,
              color: seleccionado ? Colors.deepOrange : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (descripcion.isNotEmpty)
                    Text(descripcion, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            if (precio.isNotEmpty) Text('\$$precio'),
          ],
        ),
      ),
    );
  }
}

class _ModalReserva extends StatefulWidget {
  final String nitRestaurante;
  final List<String> nombrePlatos;
  final List<dynamic> mesas;

  const _ModalReserva({
    required this.nitRestaurante,
    required this.nombrePlatos,
    required this.mesas,
  });

  @override
  State<_ModalReserva> createState() => _ModalReservaState();
}

class _ModalReservaState extends State<_ModalReserva> {
  DateTime? _fecha;
  TimeOfDay? _hora;
  String? _numMesaSeleccionada;
  final _descripcionController = TextEditingController();
  bool _enviando = false;
  String? _error;

  List<dynamic> get _mesasDisponibles {
    final filtradas = widget.mesas.where((m) {
      final estado = m['estado']?.toString().toLowerCase() ?? '';
      return estado.contains('disponible') || estado.isEmpty;
    }).toList();
    return filtradas.isNotEmpty ? filtradas : widget.mesas;
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    
    final elegida = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 90)),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  Future<void> _elegirHora() async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (elegida != null) setState(() => _hora = elegida);
  }

  Future<void> _confirmarReserva() async {
  if (_fecha == null || _hora == null || _numMesaSeleccionada == null) {
    setState(() => _error = "Completa fecha, hora y mesa");
    return;
  }

  final token = context.read<AuthProvider>().user?.token;

  if (token == null) {
    setState(() => _error = "Debes iniciar sesión de nuevo");
    return;
  }

  setState(() {
    _enviando = true;
    _error = null;
  });

  try {

    final horaStr =
        "${_hora!.hour.toString().padLeft(2, '0')}:${_hora!.minute.toString().padLeft(2, '0')}";


await ReservaService.crearReserva(
  token: token,
  nitRestaurante: widget.nitRestaurante,
  nombrePlatos: widget.nombrePlatos,
  numeroMesa: _numMesaSeleccionada!,
  fecha: _fecha!,
  hora: horaStr,
  descripcion: _descripcionController.text.trim(),
);

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("¡Reserva creada con éxito!"),
      ),
    );
    // 2. Cerramos el modal primero
Navigator.pop(context);

// 3. Forzamos la actualización o la redirección al contenedor que maneja tus pestañas
// Si tienes una vista principal (ej. MainScreen o NavigationPage) que dibuja el BottomNavigationBar,
// es mejor llamarla directamente para que cargue con el AuthProvider activo.
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => const ClienteMain(), // Reemplaza 'MainScreen' por el nombre de tu contenedor principal de pestañas
  ),
  (route) => false,
);

  } catch (e) {

    setState(() {
      _error = e.toString().replaceAll("Exception: ", "");
    });

  } finally {

    if (mounted) {
      setState(() {
        _enviando = false;
      });
    }

  }
}

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Confirmar reserva", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _CampoModal(
            icono: Icons.calendar_today,
            label: _fecha == null ? "Elegir fecha" : "${_fecha!.day}/${_fecha!.month}/${_fecha!.year}",
            onTap: _elegirFecha,
          ),
          const SizedBox(height: 10),
          _CampoModal(
            icono: Icons.access_time,
            label: _hora == null ? "Elegir hora" : _hora!.format(context),
            onTap: _elegirHora,
          ),
          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: _numMesaSeleccionada,
            decoration: InputDecoration(
              labelText: "Mesa",
              prefixIcon: const Icon(Icons.table_bar),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: _mesasDisponibles.map((m) {
              final num = m['numMesa']?.toString() ?? '';
              final cap = m['capacidad']?.toString() ?? '';
              return DropdownMenuItem(
                value: num,
                child: Text(cap.isNotEmpty ? "Mesa $num · $cap personas" : "Mesa $num"),
              );
            }).toList(),
            onChanged: (v) => setState(() => _numMesaSeleccionada = v),
          ),

          const SizedBox(height: 10),
          TextField(
            controller: _descripcionController,
            decoration: InputDecoration(
              labelText: "Notas (opcional)",
              prefixIcon: const Icon(Icons.note_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
          ),

          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _enviando ? null : _confirmarReserva,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _enviando
                  ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                  : const Text("Confirmar", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampoModal extends StatelessWidget {
  final IconData icono;
  final String label;
  final VoidCallback onTap;

  const _CampoModal({required this.icono, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icono, color: Colors.deepOrange, size: 20),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
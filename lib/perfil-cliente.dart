import 'package:dinemenow/configuracion-cliente.dart';
import 'package:dinemenow/login.dart';
import 'package:dinemenow/services/cliente-service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({super.key});

  @override
  State<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {

  // ─── ESTADO ESTADÍSTICAS ──────────────────────────────────────────────────
  int _reservas      = 0;
  int _restaurantes  = 0;
  bool _loadingStats = true;
  String? _errorStats;

  // Guardamos referencia al provider para usarla en dispose sin context
  late AuthProvider _authProvider;

  // ─── LIFECYCLE ────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    // Guardamos referencia ANTES del postFrameCallback
    _authProvider = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authProvider.addListener(_onAuthChanged);
      _cargarEstadisticas();
    });
  }

  @override
  void dispose() {
    // Usamos la referencia guardada, NO context (ya está deactivated aquí)
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  // ─── LISTENER LOGOUT ──────────────────────────────────────────────────────
  void _onAuthChanged() {
    final auth = _authProvider;
    if (auth.user == null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    }
  }

 // ─── CARGAR ESTADÍSTICAS (MOCK) ─────────────────────────────────────────────
  Future<void> _cargarEstadisticas() async {
  setState(() {
    _reservas     = 1;
    _restaurantes = 2;
    _loadingStats = false;
  });
}
  // ─── CARGAR ESTADÍSTICAS ──────────────────────────────────────────────────
  /*Future<void> _cargarEstadisticas() async {
    final user = _authProvider.user;
    if (user == null) return;

    setState(() {
      _loadingStats = true;
      _errorStats   = null;
    });

    try {
      final stats = await ClienteService.contarEstadisticasCliente(
        token: user.token ?? "",
      );
      if (mounted) {
        setState(() {
          _reservas     = stats["reservas"]     ?? 0;
          _restaurantes = stats["restaurantes"] ?? 0;
          _loadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorStats   = "No se pudieron cargar las estadísticas";
          _loadingStats = false;
        });
      }
    }
  }*/

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  String _iniciales(String nombre) {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }

  String _labelRol(String? role) {
    const Map<String, String> labels = {
      'cliente':     'Cliente',
      'restaurante': 'Restaurante',
      'chef':        'Chef',
      'mesero':      'Mesero',
      'admin':       'Administrador',
    };
    return labels[role] ?? (role ?? 'Sin rol');
  }

  

  // ─── BUILD ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    const Color naranja        = Color(0xFFE8732A);
    const Color naranjaClaro   = Color(0xFFFFF3EC);
    const Color grisTexto      = Color(0xFF6B7280);
    const Color textoPrincipal = Color(0xFF1A1A1A);

    if (user == null) {
      return const Scaffold(backgroundColor: Colors.white);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // ─── APP BAR ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mi Perfil",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textoPrincipal,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConfiguracionCliente()),
                    ),
                    icon: const Icon(Icons.settings_outlined, color: textoPrincipal),
                  ),
                ],
              ),
            ),

            // ─── CONTENIDO SCROLLABLE ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // ─── AVATAR ────────────────────────────────────────────
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: naranja,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _iniciales(user.nombre ?? ""),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── NOMBRE Y CORREO ───────────────────────────────────
                    Text(
                      (user.nombre ?? "Sin nombre"),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (user.username ?? "Sin correo"),
                      style: const TextStyle(fontSize: 14, color: grisTexto),
                    ),

                    const SizedBox(height: 24),

                    // ─── CAMPOS DE INFO ────────────────────────────────────
                    _CampoInfo(
                      icono: Icons.person_outline,
                      label: "Nombre completo",
                      valor: user.nombre ?? "Sin nombre",
                    ),
                    const SizedBox(height: 12),
                    _CampoInfo(
                      icono: Icons.mail_outline,
                      label: "Correo electrónico",
                      valor: user.username ?? "Sin correo",
                    ),
                    const SizedBox(height: 12),
                    _CampoInfo(
                      icono: Icons.badge_outlined,
                      label: "Rol",
                      valor: _labelRol(user.role),
                    ),

                    const SizedBox(height: 20),

                    // ─── BOTÓN EDITAR PERFIL ───────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: navegar a editar perfil
                        },
                        icon: const Icon(Icons.edit_outlined, color: naranja, size: 18),
                        label: const Text(
                          "Editar perfil",
                          style: TextStyle(
                            color: naranja,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: naranjaClaro,
                          side: const BorderSide(color: Color(0xFFFFD9C0), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── ESTADÍSTICAS REALES ───────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      // ⚠️ SIN const — los valores son variables de instancia
                      child: _loadingStats
                          ? const SizedBox(
                              height: 48,
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFE8732A),
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _Estadistica(
                                  numero:   "$_reservas",
                                  etiqueta: "Reservas",
                                ),
                                _Divisor(),
                                _Estadistica(
                                  numero:   "$_restaurantes",
                                  etiqueta: "Restaurantes",
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ─── BOTTOM NAV ──────────────────────────────────────────────
            const _BottomNav(naranja: naranja),
          ],
        ),
      ),
    );
  }
}

// ─── WIDGET: Campo de información ─────────────────────────────────────────────
class _CampoInfo extends StatelessWidget {
  final IconData icono;
  final String label;
  final String valor;

  const _CampoInfo({
    required this.icono,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFFE8732A), size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── WIDGET: Estadística ──────────────────────────────────────────────────────
class _Estadistica extends StatelessWidget {
  final String numero;
  final String etiqueta;

  const _Estadistica({required this.numero, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numero,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 2),
        Text(etiqueta, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}

// ─── WIDGET: Divisor vertical ─────────────────────────────────────────────────
class _Divisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 36, width: 1, color: Colors.black12);
  }
}

// ─── WIDGET: Bottom Navigation ────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final Color naranja;
  const _BottomNav({required this.naranja});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12, width: 1)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icono: Icons.home_outlined,           label: "Inicio",   activo: false, color: naranja),
          _NavItem(icono: Icons.calendar_today_outlined, label: "Reservas", activo: false, color: naranja),
          _NavItemConBadge(icono: Icons.notifications_outlined, label: "Alertas", badge: "2", color: naranja),
          _NavItem(icono: Icons.person_outlined,         label: "Perfil",   activo: true,  color: naranja),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icono;
  final String label;
  final bool activo;
  final Color color;

  const _NavItem({required this.icono, required this.label, required this.activo, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, color: activo ? color : Colors.black38, size: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: activo ? color : Colors.black38,
            fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _NavItemConBadge extends StatelessWidget {
  final IconData icono;
  final String label;
  final String badge;
  final Color color;

  const _NavItemConBadge({required this.icono, required this.label, required this.badge, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icono, color: Colors.black38, size: 24),
            Positioned(
              top: -4,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black38)),
      ],
    );
  }
}
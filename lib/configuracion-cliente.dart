import 'package:dinemenow/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

class ConfiguracionCliente extends StatefulWidget {
  const ConfiguracionCliente({super.key});

  @override
  State<ConfiguracionCliente> createState() => _ConfiguracionClienteState();
}

class _ConfiguracionClienteState extends State<ConfiguracionCliente> {
  // ─── ESTADO DE NOTIFICACIONES ─────────────────────────────────────────────
  bool _confirmaciones = true;
  bool _recordatorios = true;
  bool _ofertas = false;
  bool _novedades = false;
  late AuthProvider _authProvider;
  bool _listenerAdded = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_listenerAdded) {
    _authProvider = context.read<AuthProvider>();
    _authProvider.addListener(_onAuthChanged);
    _listenerAdded = true;
  }
}

@override
void dispose() {
  if (_listenerAdded) {
    _authProvider.removeListener(_onAuthChanged);
  }
  super.dispose();
}

  void _onAuthChanged() {
    final auth = context.read<AuthProvider>();
    if (auth.user == null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    }
  }

  // ─── CONFIRMAR LOGOUT ─────────────────────────────────────────────────────
  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
            },
            child: const Text(
              "Salir",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color naranja = Color(0xFFE8732A);
    const Color textoPrincipal = Color(0xFF1A1A1A);
    const Color grisTexto = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // ─── APP BAR ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: textoPrincipal),
                  ),
                  const Text(
                    "Configuración",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textoPrincipal,
                    ),
                  ),
                ],
              ),
            ),

            // ─── CONTENIDO ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── SECCIÓN SEGURIDAD ────────────────────────────────
                    _SeccionHeader(
                      icono: Icons.shield_outlined,
                      label: "Seguridad",
                      color: naranja,
                    ),
                    const SizedBox(height: 8),
                    _CardSeccion(
                      child: _FilaAccion(
                        label: "Cambiar contraseña",
                        icono: Icons.lock_outline,
                        onTap: () {
                          // TODO: navegar a cambiar contraseña
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── SECCIÓN NOTIFICACIONES ───────────────────────────
                    _SeccionHeader(
                      icono: Icons.notifications_outlined,
                      label: "Notificaciones",
                      color: naranja,
                    ),
                    const SizedBox(height: 8),
                    _CardSeccion(
                      child: Column(
                        children: [
                          _FilaToggle(
                            label: "Confirmaciones de reserva",
                            value: _confirmaciones,
                            color: naranja,
                            onChanged: (v) =>
                                setState(() => _confirmaciones = v),
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _FilaToggle(
                            label: "Recordatorios",
                            value: _recordatorios,
                            color: naranja,
                            onChanged: (v) =>
                                setState(() => _recordatorios = v),
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _FilaToggle(
                            label: "Ofertas y promociones",
                            value: _ofertas,
                            color: naranja,
                            onChanged: (v) => setState(() => _ofertas = v),
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _FilaToggle(
                            label: "Novedades de DineMeNow",
                            value: _novedades,
                            color: naranja,
                            onChanged: (v) => setState(() => _novedades = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── BOTÓN CERRAR SESIÓN ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _confirmarLogout,
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFE8732A),
                          size: 20,
                        ),
                        label: const Text(
                          "Cerrar sesión",
                          style: TextStyle(
                            color: Color(0xFFE8732A),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF0ED),
                          side: const BorderSide(
                            color: Color(0xFFFFD0C0),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ─── WIDGET: Encabezado de sección ───────────────────────────────────────────
class _SeccionHeader extends StatelessWidget {
  final IconData icono;
  final String label;
  final Color color;

  const _SeccionHeader({
    required this.icono,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

// ─── WIDGET: Card contenedor de sección ──────────────────────────────────────
class _CardSeccion extends StatelessWidget {
  final Widget child;
  const _CardSeccion({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: child,
    );
  }
}

// ─── WIDGET: Fila de acción (con flecha) ─────────────────────────────────────
class _FilaAccion extends StatelessWidget {
  final String label;
  final IconData icono;
  final VoidCallback onTap;

  const _FilaAccion({
    required this.label,
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icono, size: 18, color: const Color(0xFF6B7280)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── WIDGET: Fila con Toggle ──────────────────────────────────────────────────
class _FilaToggle extends StatelessWidget {
  final String label;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const _FilaToggle({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: color,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD1D5DB),
          ),
        ],
      ),
    );
  }
}
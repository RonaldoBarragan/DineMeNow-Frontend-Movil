import 'package:dinemenow/services/reserva_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinemenow/services/restaurante_service.dart';
import 'package:dinemenow/providers/auth_provider.dart';
import 'package:dinemenow/widgets/navegacion.dart';
import 'package:dinemenow/restaurante_detalle.dart';

class Cliente_home extends StatefulWidget {
  const Cliente_home({Key? key}) : super(key: key);

  @override
  State<Cliente_home> createState() => _Cliente_homeState();
}

class _Cliente_homeState extends State<Cliente_home> {
  bool _showFilters = false;

  final RestauranteService _apiService = RestauranteService();
  List<dynamic> _restaurantes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final ValueNotifier<String> _selectedCocinaNotifier = ValueNotifier<String>(
    'Todas',
  );
  final ValueNotifier<String> _selectedZonaNotifier = ValueNotifier<String>(
    'Todas',
  );
  final ValueNotifier<String> _selectedPrecioNotifier = ValueNotifier<String>(
    'Todos',
  );

  final List<String> cocinas = [
    'Todas',
    'Colombiana',
    'Italiana',
    'Japonesa',
    'Francesa',
  ];

  @override
  void initState() {
    super.initState();
    // postFrameCallback para poder leer el AuthProvider de forma segura
    // apenas el widget termina de montarse.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _obtenerRestaurantes();
    });
  }

  Future<void> _obtenerRestaurantes() async {
    final user = context.read<AuthProvider>().user;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await _apiService.obtenerRestaurantes(
        token: user?.token,
      );
      if (!mounted) return;
      setState(() {
        _restaurantes = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'No se pudo conectar al servidor de DineMeNow.\nVerifica si Spring Boot está corriendo.';
        _isLoading = false;
      });
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Usuario logueado, viene del AuthProvider (no de una lista de clientes)
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(user?.nombre),
                    const SizedBox(height: 16),
                    _buildSearchBar(),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _showFilters ? 220 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _showFilters ? 1.0 : 0.0,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildInlineFilterSection(
                                title: 'Cocina',
                                options: cocinas,
                                notifier: _selectedCocinaNotifier,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange),
                  ),
                ),
              )
            else if (_errorMessage.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              )
            else if (_restaurantes.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No hay restaurantes disponibles por el momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final restaurante = _restaurantes[index];
                      return _RestauranteCard(
                        restaurante: restaurante,
                        onTap: () {
                          final nit = restaurante['nit']?.toString();
                          if (nit == null || nit.isEmpty) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestauranteDetalle(
                                nit: nit,
                                nombrePreview: restaurante['nombre']?.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: _restaurantes.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String? nombreUsuario) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bogotá, Colombia',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.orange, size: 18),
                SizedBox(width: 4),
                Text(
                  'Selecciona zona',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.deepOrange,
          child: Text(
            _getInitials(nombreUsuario),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Text(
                  'Restaurante, cocina, zona...',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _showFilters ? Colors.orange[800] : Colors.deepOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineFilterSection({
    required String title,
    required List<String> options,
    required ValueNotifier<String> notifier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ValueListenableBuilder<String>(
            valueListenable: notifier,
            builder: (context, currentSelection, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = currentSelection == option;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      label: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.deepOrange,
                      backgroundColor: Colors.grey[100],
                      elevation: 0,
                      pressElevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      onSelected: (accepted) {
                        if (accepted) {
                          notifier.value = option;
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── WIDGET: Tarjeta de restaurante ───────────────────────────────────────
// Campos alineados con RestauranteDto real: nombre, categoria, direccion.
class _RestauranteCard extends StatelessWidget {
  final dynamic restaurante;
  final VoidCallback onTap;

  const _RestauranteCard({required this.restaurante, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final nombre = restaurante['nombre']?.toString() ?? 'Restaurante';
    final categoria = restaurante['categoria']?.toString() ?? '';
    final ciudad = restaurante['direccion']?['ciudad']?.toString() ?? '';
    final subtitulo = [categoria, ciudad]
        .where((e) => e.isNotEmpty)
        .join(' · ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.restaurant, color: Colors.deepOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (subtitulo.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      ),
    );
  }
}
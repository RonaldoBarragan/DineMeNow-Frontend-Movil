import 'package:flutter/material.dart';
import 'package:dinemenow/RestaurantCard.dart';
// Asegúrate de que esta ruta apunte correctamente a donde guardaste tu servicio
import 'package:dinemenow/services/homepage_services.dart';

class Cliente_home extends StatefulWidget {
  const Cliente_home({Key? key}) : super(key: key);

  @override
  State<Cliente_home> createState() => _Cliente_homeState();
}

class _Cliente_homeState extends State<Cliente_home> {
  // Variable de control para expandir/colapsar los filtros
  bool _showFilters = false;

  // --- CONEXIÓN CON EL SERVICIO ---
  final ClienteService _apiService = ClienteService();
  List<dynamic> _clientes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Notifiers para guardar la selección de los chips
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
  final List<String> zonas = [
    'Todas',
    'Zona Rosa',
    'Chapinero',
    'Zona T',
    'Usaquén',
  ];
  final List<String> precios = ['Todos', '\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  // --- CICLO DE VIDA: CARGA LA API AL INICIAR ---
  @override
  void initState() {
    super.initState();
    _obtenerDatosDelBackend();
  }

  Future<void> _obtenerDatosDelBackend() async {
    try {
      final data = await _apiService.obtenerAllClientes();
      setState(() {
        _clientes = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'No se pudo conectar al servidor de DineMeNow.\nVerifica si Spring Boot está corriendo.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSearchBar(),

                    // --- SECCIÓN DE FILTROS ANIMADOS (ABRE/CIERRA) ---
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
                              const SizedBox(height: 14),
                              _buildInlineFilterSection(
                                title: 'Zona',
                                options: zonas,
                                notifier: _selectedZonaNotifier,
                              ),
                              const SizedBox(height: 14),
                              _buildInlineFilterSection(
                                title: 'Precio',
                                options: precios,
                                notifier: _selectedPrecioNotifier,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Resultados desde el Backend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- RENDERIZADO CONDICIONAL DE LA API ---
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
            else if (_clientes.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No hay registros disponibles en este momento.',
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // Obtenemos el cliente/item actual de la lista
                    final item = _clientes[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RestaurantCard(
                        // NOTA: Reemplaza las llaves 'nombre', 'correo' por las que vengan en tu ClienteDto de Java
                        name: item['nombre'] ?? 'Sin Nombre',
                        cuisineAndZone: item['correo'] ?? 'Sin Correo',
                        imageUrl:
                            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                        distance: 'Activo',
                        closingTime: '--:--',
                        priceCategory: '\$\$',
                        rating: 5.0,
                      ),
                    );
                  }, childCount: _clientes.length),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Componente de Ubicación y Botón de Ayuda
  Widget _buildHeader() {
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.circle,
          ),
          child: const Text(
            '?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Componente de Barra de Búsqueda (Con Toggle de Filtros)
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

  // Componente para las filas de Chips
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

  // Componente de la Barra de Navegación Inferior
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_outlined),
          label: 'Alertas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}

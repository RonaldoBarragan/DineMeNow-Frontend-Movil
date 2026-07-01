import 'package:flutter/material.dart';
import 'package:dinemenow/services/homepage_services.dart';
import 'package:dinemenow/widgets/navegacion.dart'; // Asegúrate de importar tu nuevo widget aquí
// Asegúrate de importar tu nuevo widget aquí:
// import 'package:dinemenow/widgets/custom_bottom_navigation_bar.dart';

class Cliente_home extends StatefulWidget {
  const Cliente_home({Key? key}) : super(key: key);

  @override
  State<Cliente_home> createState() => _Cliente_homeState();
}

class _Cliente_homeState extends State<Cliente_home> {
  bool _showFilters = false;

  // 1. NUEVA VARIABLE PARA CONTROLAR EL ÍNDICE ACTUAL
  int _currentIndex = 0;

  final ClienteService _apiService = ClienteService();
  List<dynamic> _clientes = [];
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

  String get _nombreClienteLogueado {
    if (_clientes.isEmpty) return '';
    return _clientes[0]['nombreCliente'] ?? '';
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
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
            else
              const SliverToBoxAdapter(child: SizedBox.shrink()),
          ],
        ),
      ),
      // 2. WIDGET REUTILIZADO PARA LA BARRA DE NAVEGACIÓN INFERIOR
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

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
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.deepOrange,
          child: Text(
            _getInitials(_nombreClienteLogueado),
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
